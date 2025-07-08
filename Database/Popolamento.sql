-- Popolamento della tabella UTENTE
INSERT INTO utente (login, password, ruolo) VALUES ('marco.rossi', 'password123', 'Generico');
INSERT INTO utente (login, password, ruolo) VALUES ('anna.bianchi', 'securepass', 'Generico');
INSERT INTO utente (login, password, ruolo) VALUES ('admin.alfa', 'adminpass', 'Amministratore');
INSERT INTO utente (login, password, ruolo) VALUES ('admin.beta', 'supersecret', 'Amministratore');

-- Popolamento della tabella GATE
INSERT INTO gate (numero) VALUES (1);
INSERT INTO gate (numero) VALUES (2);
INSERT INTO gate (numero) VALUES (3);
INSERT INTO gate (numero) VALUES (4);

-- Popolamento della tabella VOLO
INSERT INTO volo (codice, compagnia_aerea, data, orario, stato_volo, tipo_volo, aeroporto_origine, aeroporto_destinazione, idGateFK)
VALUES ('AZ101', 'Alitalia', '2025-08-05', '10:30:00', 'Programmato', 'Partenza', 'Napoli', 'Roma', 1);

INSERT INTO volo (codice, compagnia_aerea, data, orario, stato_volo, tipo_volo, aeroporto_origine, aeroporto_destinazione, idGateFK)
VALUES ('LH202', 'Lufthansa', '2025-08-06', '14:00:00', 'Programmato', 'Partenza', 'Napoli', 'Francoforte', 2);

INSERT INTO volo (codice, compagnia_aerea, data, orario, stato_volo, tipo_volo, aeroporto_origine, aeroporto_destinazione, idGateFK)
VALUES ('BA303', 'British Airways', '2025-08-07', '08:45:00', 'In Ritardo', 'Partenza', 'Napoli', 'Londra', 3);

INSERT INTO volo (codice, compagnia_aerea, data, orario, stato_volo, tipo_volo, aeroporto_origine, aeroporto_destinazione, idGateFK)
VALUES ('AF404', 'Air France', '2025-08-05', '12:00:00', 'Programmato', 'Arrivo', 'Parigi', 'Napoli', NULL);

INSERT INTO volo (codice, compagnia_aerea, data, orario, stato_volo, tipo_volo, aeroporto_origine, aeroporto_destinazione, idGateFK)
VALUES ('RY505', 'Ryanair', '2025-08-06', '16:15:00', 'Cancellato', 'Partenza', 'Napoli', 'Barcellona', 4);

-- Popolamento della tabella PRENOTAZIONE
INSERT INTO prenotazione (nome_passeggero, numero_biglietto, posto_assegnato, stato_prenotazione, idUtenteFK, idVoloFK)
VALUES ('Mario Rossi', 'MR1234', 'A1', 'Confermata', 1, 1);

INSERT INTO prenotazione (nome_passeggero, numero_biglietto, posto_assegnato, stato_prenotazione, idUtenteFK, idVoloFK)
VALUES ('Giulia Verdi', 'GV5678', 'A2', 'Confermata', 2, 1);

INSERT INTO prenotazione (nome_passeggero, numero_biglietto, posto_assegnato, stato_prenotazione, idUtenteFK, idVoloFK)
VALUES ('Luca Neri', 'LN9012', 'B1', 'In Attesa', 1, 2);

INSERT INTO prenotazione (nome_passeggero, numero_biglietto, posto_assegnato, stato_prenotazione, idUtenteFK, idVoloFK)
VALUES ('Elena Gialli', 'EG3456', 'C3', 'Confermata', 2, 3);

-- Popolamento della tabella GESTIONE
INSERT INTO gestione (idUtente, idVolo) VALUES (3, 1);
INSERT INTO gestione (idUtente, idVolo) VALUES (3, 2);
INSERT INTO gestione (idUtente, idVolo) VALUES (4, 3);
INSERT INTO gestione (idUtente, idVolo) VALUES (4, 5);
