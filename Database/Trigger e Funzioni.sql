-- Funzione generica per la generazione automatica degli ID sequenziali
CREATE OR REPLACE FUNCTION Genera_ID_Sequenziale()
RETURNS TRIGGER AS $$
DECLARE
    nome_sequenza TEXT;
BEGIN
  IF TG_NARGS > 0 THEN
      nome_sequenza := TG_ARGV[0];
  ELSE
      RAISE EXCEPTION 'Erorre interno: la funzione Genera_ID_Sequenziale è stata richiamata senza il nome della sequenza.';
  END IF;

BEGIN
  CASE TG_TABLE_NAME
    WHEN 'utente' THEN
      IF NEW.idUtente IS NULL THEN
        NEW.idUtente := NEXTVAL(nome_sequenza);
      END IF;
    WHEN 'gate' THEN
      IF NEW.idGate IS NULL THEN
        NEW.idGate := NEXTVAL(nome_sequenza);
      END IF;
    WHEN 'prenotazione' THEN
      IF NEW.idPrenotazione IS NULL THEN
        NEW.idPrenotazione := NEXTVAL(nome_sequenza);
      END IF;
    WHEN 'volo' THEN
      IF NEW.idVolo IS NULL THEN
        NEW.idVolo := NEXTVAL(nome_sequenza);
      END IF;
    ELSE
        RAISE EXCEPTION 'Errore: la tabella % non è gestita dalla funzione Genera_ID_Sequenziale.', TG_TABLE_NAME;
  END CASE;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Funzione per verificare che un volo di tipo 'Partenza' abbia un gate assegnato
CREATE OR REPLACE FUNCTION Check_Gate_Volo_Partenza()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_volo = 'Partenza' AND NEW.idGateFK IS NULL THEN
        RAISE EXCEPTION 'Un volo di tipo "Partenza" deve avere un GATE assegnato.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Funzione per aggiornare lo stato delle prenotazioni quando il volo viene cancellato
CREATE OR REPLACE FUNCTION Aggiorna_Prenotazioni_Volo_Cancellato()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.stato_volo <> 'Cancellato' AND NEW.stato_volo = 'Cancellato' THEN
        UPDATE prenotazione
        SET stato_prenotazione = 'Cancellata'
        WHERE idVoloFK = NEW.idVolo AND stato_prenotazione <> 'Cancellata';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Funzione per garantire che il posto assegnato sia unico per un dato volo
CREATE OR REPLACE FUNCTION Check_Posto_Unico_Per_Volo()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM prenotazione
        WHERE idVoloFK = NEW.idVoloFK
          AND posto_assegnato = NEW.posto_assegnato
          AND (TG_OP = 'INSERT' OR idPrenotazione <> NEW.idPrenotazione)
    ) THEN
        RAISE EXCEPTION 'Il posto % è già assegnato per il volo %.', NEW.posto_assegnato, NEW.idVoloFK;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Funzione per controllare che il formato del numero del biglietto sia valido
CREATE OR REPLACE FUNCTION Check_Formato_Numero_Biglietto()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT NEW.numero_biglietto ~ '^[A-Z]{2}[0-9]{4}$' THEN
        RAISE EXCEPTION 'Il formato del numero di biglietto non è valido. Deve essere: 2 lettere e 4 cifre (es. AB1234).';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Funzione per verificare che solo gli amministratori possano gestire voli
CREATE OR REPLACE FUNCTION Check_Ruolo_Amministratore_Gestione()
RETURNS TRIGGER AS $$
DECLARE
    utente_ruolo VARCHAR(100);
BEGIN
    SELECT ruolo INTO utente_ruolo
    FROM utente
    WHERE idUtente = NEW.idUtente;

    IF utente_ruolo IS DISTINCT FROM 'Amministratore' THEN
        RAISE EXCEPTION 'Solo gli utenti con ruolo ''Amministratore'' possono essere assegnati alla gestione dei voli.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;





-- Trigger per l'auto-incremento dell'ID utente tramite funzione generica
CREATE TRIGGER Trigger_Sequenza_Utente
BEFORE INSERT ON utente
FOR EACH ROW
EXECUTE FUNCTION Genera_ID_Sequenziale('SEQ_UTENTE');

-- Trigger per l'auto-incremento dell'ID gate tramite funzione generica
CREATE TRIGGER Trigger_Sequenza_Gate
BEFORE INSERT ON gate
FOR EACH ROW
EXECUTE FUNCTION Genera_ID_Sequenziale('SEQ_GATE');

-- Trigger per l'auto-incremento dell'ID prenotazione tramite funzione generica
CREATE TRIGGER Trigger_Sequenza_Prenotazione
BEFORE INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION Genera_ID_Sequenziale('SEQ_PRENOTAZIONE');

-- Trigger per l'auto-incremento dell'ID volo tramite funzione generica
CREATE TRIGGER Trigger_Sequenza_Volo
BEFORE INSERT ON volo
FOR EACH ROW
EXECUTE FUNCTION Genera_ID_Sequenziale('SEQ_VOLO');

-- Trigger che attiva la funzione prima dell'inserimento o aggiornamento di un volo
CREATE TRIGGER Trigger_Check_Gate_Volo_Partenza
BEFORE INSERT OR UPDATE OF tipo_volo, idGateFK ON volo
FOR EACH ROW
EXECUTE FUNCTION Check_Gate_Volo_Partenza();

-- Trigger che si attiva dopo l'aggiornamento dello stato del volo
CREATE TRIGGER Trigger_Aggiorna_Prenotazioni_Volo_Cancellato
AFTER UPDATE OF stato_volo ON volo
FOR EACH ROW
EXECUTE FUNCTION Aggiorna_Prenotazioni_Volo_Cancellato();

-- Trigger che si attiva prima di ogni INSERT o UPDATE sulla tabella PRENOTAZIONE
CREATE TRIGGER Trigger_Check_Posto_Unico_Per_Volo
BEFORE INSERT OR UPDATE ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION Check_Posto_Unico_Per_Volo();

-- Trigger che si attiva prima di ogni INSERT o UPDATE sulla tabella PRENOTAZIONE
CREATE TRIGGER Trigger_Check_Formato_Numero_Biglietto
BEFORE INSERT OR UPDATE ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION Check_Formato_Numero_Biglietto();

-- Trigger che si attiva prima dell'inserimento in GESTIONE
CREATE TRIGGER Trigger_Check_Ruolo_Amministratore_Gestione
BEFORE INSERT ON gestione
FOR EACH ROW
EXECUTE FUNCTION Check_Ruolo_Amministratore_Gestione();
