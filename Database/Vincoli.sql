-- Vincolo di unicità per il login dell'utente
ALTER TABLE utente
ADD CONSTRAINT UNQ_Utente_Login UNIQUE (login);


-- Vincolo di controllo per il ruolo dell'utente
ALTER TABLE utente
ADD CONSTRAINT CHK_Utente_Ruolo CHECK (ruolo IN ('Generico', 'Amministratore'));


-- Vincolo di controllo per il numero del gate
ALTER TABLE gate
ADD CONSTRAINT CHK_Gate_Numero CHECK (numero > 0);


-- Vincolo di unicità per il numero del biglietto della prenotazione
ALTER TABLE prenotazione
ADD CONSTRAINT UNQ_Prenotazione_NumeroBiglietto UNIQUE (numero_biglietto);


-- Vincolo di controllo per lo stato della prenotazione
ALTER TABLE prenotazione
ADD CONSTRAINT CHK_Prenotazione_Stato CHECK (stato_prenotazione IN ('Confermata', 'Annullata', 'In Attesa', 'Effettuata'));


-- Vincolo di chiave esterna per collegare la prenotazione all'utente
ALTER TABLE prenotazione
ADD CONSTRAINT FK_Prenotazione_Utente FOREIGN KEY (idUtenteFK) REFERENCES utente(idUtente) ON DELETE CASCADE;


-- Vincolo di chiave esterna per collegare la prenotazione al volo
ALTER TABLE prenotazione
ADD CONSTRAINT FK_Prenotazione_Volo FOREIGN KEY (idVoloFK) REFERENCES volo(idVolo) ON DELETE CASCADE;


-- Vincolo di unicità per il codice del volo
ALTER TABLE volo
ADD CONSTRAINT UNQ_Volo_Codice UNIQUE (codice);



-- Vincolo di controllo per il ritardo del volo
ALTER TABLE volo
ADD CONSTRAINT CHK_Volo_Ritardo CHECK (ritardo >= '00:00:00');


-- Vincolo di controllo per lo stato del volo
ALTER TABLE volo
ADD CONSTRAINT CHK_Volo_Stato CHECK (stato_volo IN ('In Orario', 'In Ritardo', 'Cancellato', 'Partito', 'Atterrato'));


-- Vincolo di controllo per il tipo di volo
ALTER TABLE volo
ADD CONSTRAINT CHK_Volo_Tipo CHECK (tipo_volo IN ('Partenza', 'Arrivo'));


-- Vincolo di controllo per assicurare che aeroporto di origine e destinazione siano diversi
ALTER TABLE volo
ADD CONSTRAINT CHK_Volo_AeroportiDiversi CHECK (aeroporto_origine <> aeroporto_destinazione);


-- Vincolo di chiave esterna per collegare il volo al gate
ALTER TABLE volo
ADD CONSTRAINT FK_Volo_Gate FOREIGN KEY (idGateFK) REFERENCES gate(idGate) ON DELETE SET NULL;


-- Vincolo di chiave esterna per collegare la tabella GESTIONE all'utente
ALTER TABLE gestione
ADD CONSTRAINT FK_Gestione_Utente FOREIGN KEY (idUtente) REFERENCES utente(idUtente) ON DELETE CASCADE;


-- Vincolo di chiave esterna per collegare la tabella GESTIONE al volo
ALTER TABLE gestione
ADD CONSTRAINT FK_Gestione_Volo FOREIGN KEY (idVolo) REFERENCES volo(idVolo) ON DELETE CASCADE;