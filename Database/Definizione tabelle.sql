-- Definizione della tabella UTENTE
CREATE TABLE utente (
  idUtente INTEGER PRIMARY KEY,
  login VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  ruolo VARCHAR(50) NOT NULL
);


-- Definizione della tabella GATE
CREATE TABLE gate (
  idGate INTEGER PRIMARY KEY,
  numero INTEGER NOT NULL
);


-- Definizione della tabella PRENOTAZIONE
CREATE TABLE prenotazione (
  idPrenotazione INTEGER PRIMARY KEY,
  nome_passeggero VARCHAR(255) NOT NULL,
  numero_biglietto VARCHAR(255) NOT NULL,
  posto_assegnato VARCHAR(255) NOT NULL,
  stato_prenotazione VARCHAR(50) NOT NULL,
  idUtenteFK INTEGER NOT NULL,
  idVoloFK INTEGER NOT NULL
);


-- Definizione della tabella VOLO
CREATE TABLE volo (
  idVolo INTEGER PRIMARY KEY,
  codice VARCHAR(255) NOT NULL,
  compagnia_aerea VARCHAR(255) NOT NULL,
  data DATE NOT NULL,
  orario TIME NOT NULL,
  ritardo TIME DEFAULT '00:00:00',
  stato_volo VARCHAR(50) NOT NULL,
  tipo_volo VARCHAR(50) NOT NULL,
  aeroporto_origine VARCHAR(255) DEFAULT 'Napoli',
  aeroporto_destinazione VARCHAR(255) DEFAULT 'Napoli',
  idGateFK INTEGER
);


-- Definizione della tabella GESTIONE (Tabella di associazione N:M tra UTENTE e VOLO)
CREATE TABLE gestione (
  idUtente INTEGER,
  idVolo INTEGER,
  PRIMARY KEY (idUtente, idVolo)
);