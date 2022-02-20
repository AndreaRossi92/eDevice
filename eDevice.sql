SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

BEGIN;
CREATE DATABASE IF NOT EXISTS  eDevice ; 
COMMIT;

/*--------------------------------------------------------------AREA PRODUZIONE------------------------------------------------------------------------------*/
USE  `eDevice`;

-- PRODOTTO (CodSeriale, Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia)
DROP TABLE IF EXISTS `Prodotto`;
CREATE TABLE `Prodotto` (
			CodSeriale int NOT NULL auto_increment,			
            Nome char(100) NOT NULL,			
            Marca char(100) NOT NULL,
            Modello char(100) NOT NULL,
            Tipo char(100) NOT NULL,							-- {Disponibile, Non Disponibile, Venduto, Ricondizionato}
            Facce int NOT NULL,
            Costo double NOT NULL,
            DataProduzione date NOT NULL,			-- in verità vuole solo anno e mese, quindi basta guardare solo quelli
            Sconto double,
            Stato char(100) NOT NULL, 					--  {Disponibile, Non Disponibile, Ricondizionato, Venduto} 
            Lotto int NOT NULL,					-- codice lotto
            Garanzia int NOT NULL,				-- codice garanzia
            PRIMARY KEY (CodSeriale),
            FOREIGN KEY (Lotto) REFERENCES Lotto(CodLotto),
            FOREIGN KEY (Garanzia) REFERENCES Garanzia(CodGaranzia)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- VARIANTE (CodVariante, Colore, Descrizione)
DROP TABLE IF EXISTS `Variante`;
CREATE TABLE `Variante` (
			CodVariante int NOT NULL,
            Colore char(100),										-- la variazione può essere diversa dal colore
            Descrizione char(100) NOT NULL,			
            PRIMARY KEY (CodVariante)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- CARATTERIZZAZIONE (Prodotto, Variante)
DROP TABLE IF EXISTS `Caratterizzazione`;
CREATE TABLE `Caratterizzazione` (
			Prodotto int NOT NULL,
			Variante int NOT NULL,
            PRIMARY KEY (Prodotto, Variante),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
            FOREIGN KEY (Variante) REFERENCES Variante(CodVariante)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- PARTE (CodParte, Nome, Peso, Prezzo, CoeffSvalutazione)
DROP TABLE IF EXISTS `Parte`;
CREATE TABLE `Parte` (
			CodParte int NOT NULL AUTO_INCREMENT,
            Nome char(100) NOT NULL,
            Peso int NOT NULL,
            Prezzo int NOT NULL,
            CoeffSvalutazione double NOT NULL,		-- percentuale
            PRIMARY KEY (CodParte)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- COMPOSIZIONE (Prodotto, Parte)
DROP TABLE IF EXISTS `Composizione`;
CREATE TABLE `Composizione` (
			Prodotto int NOT NULL,
			Parte int NOT NULL,
            PRIMARY KEY (Prodotto, Parte),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
            FOREIGN KEY (Parte) REFERENCES Parte(CodParte)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- MATERIALE (Nome, Valore)
DROP TABLE IF EXISTS `Materiale`;
CREATE TABLE `Materiale` (
            Nome char(100) NOT NULL,
            Valore double NOT NULL,								-- espressa in euro
            PRIMARY KEY (Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- COSTITUZIONE (Parte, Materiale, Quantità)
DROP TABLE IF EXISTS `Costituzione`;
CREATE TABLE `Costituzione` (
		    Parte int NOT NULL,
            Materiale char(100) NOT NULL,
            Quantità int NOT NULL,					-- espressa in grammi, si riferisce al materiale
            PRIMARY KEY (Parte, Materiale),
            FOREIGN KEY (Parte) REFERENCES Parte(CodParte),
            FOREIGN KEY (Materiale) REFERENCES Materiale(Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- GIUNZIONE (Nome, Tipo, Caratteristiche)
DROP TABLE IF EXISTS `Giunzione`;
CREATE TABLE `Giunzione` (
            Nome char(100) NOT NULL,
            Tipo char(100) NOT NULL,
            Caratteristiche char(255) NOT NULL,			
            PRIMARY KEY (Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- FISSAGGIO (Parte, Giunzione)
DROP TABLE IF EXISTS `Fissaggio`;
CREATE TABLE `Fissaggio` (
		    Parte int NOT NULL,
            Giunzione char(100) NOT NULL,
            PRIMARY KEY (Parte, Giunzione),
            FOREIGN KEY (Parte) REFERENCES Parte(CodParte),
            FOREIGN KEY (Giunzione) REFERENCES Giunzione(Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- OPERAZIONE (CodOperazione , Nome, Faccia, TempoMedio)
DROP TABLE IF EXISTS `Operazione`;
CREATE TABLE `Operazione` (
			CodOperazione  int NOT NULL auto_increment, 	
            Nome char(100) NOT NULL,
            Faccia char(100) NOT NULL,							--  DOVE AGISCE L'OPERATORE 	(basta controllare che in ogni stazione tutte le operazioni abbiano lo stesso orientamento)
            TempoMedio int NOT NULL DEFAULT 0,							-- espresso in minuti
            PRIMARY KEY (CodOperazione )
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- ASSEMBLAGGIO (Parte, Operazione, Ranking)
DROP TABLE IF EXISTS `Assemblaggio`;
CREATE TABLE `Assemblaggio` (
		    Parte int NOT NULL,
            Operazione int NOT NULL,
            Ranking int NOT NULL,
            PRIMARY KEY (Parte, Operazione),
            FOREIGN KEY (Parte) REFERENCES Parte(CodParte),
            FOREIGN KEY (Operazione) REFERENCES Operazione(CodOperazione )
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- UTENSILE (Nome, Caratteristiche)
DROP TABLE IF EXISTS `Utensile`;
CREATE TABLE `Utensile` (
            Nome char(100) NOT NULL,
            Caratteristiche char(255),			
            PRIMARY KEY (Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- UTILIZZO (Operazione, Utensile)
DROP TABLE IF EXISTS `Utilizzo`;
CREATE TABLE `Utilizzo` (
            Operazione int NOT NULL,
            Utensile char(100) NOT NULL,
            PRIMARY KEY (Operazione, Utensile),
            FOREIGN KEY (Operazione) REFERENCES Operazione(CodOperazione ),
            FOREIGN KEY (Utensile) REFERENCES Utensile(Nome)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- STAZIONE (NStazione, OrientamentoProdotto, TempoMedio, Linea, Ordinamento)
DROP TABLE IF EXISTS `Stazione`;
CREATE TABLE `Stazione` (
            NStazione int NOT NULL auto_increment,						
            OrientamentoProdotto char(100) NOT NULL,		
            TempoMedio int NOT NULL DEFAULT 0,			-- espresso in minuti
			Linea int ,
            Ordinamento int NOT NULL,
            PRIMARY KEY (NStazione),														
            FOREIGN KEY (Linea) REFERENCES LineaAssemblaggio(CodLinea)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment =1;
 
 -- UNITA' PERSE (Prodotto, Stazione, Istante, OperazioneInterrotta)
 DROP TABLE IF EXISTS `UnitaPerse`;
 CREATE TABLE `UnitaPerse` (
			Prodotto int NOT NULL,
            Stazione int NOT NULL,
            Istante datetime NOT NULL,
            OperazioneInterrotta int NOT NULL,
            PRIMARY KEY (Prodotto, Stazione, Istante),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
            FOREIGN KEY (Stazione) REFERENCES Stazione(NStazione),
            FOREIGN KEY (OperazioneInterrotta) REFERENCES Operazione(CodOperazione)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;            
 
  -- ASSEGNAMENTO (Stazione, Operazione, Ranking)						
 DROP TABLE IF EXISTS `Assegnamento`;
 CREATE TABLE `Assegnamento`(
			Stazione int NOT NULL,
            Operazione int NOT NULL,
            Ranking int NOT NULL,
            PRIMARY KEY (Stazione, Operazione),
            FOREIGN KEY (Stazione) REFERENCES Stazione(NStazione),
            FOREIGN KEY (Operazione) REFERENCES Operazione(CodOperazione )
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- OPERATORE (Matricola, Nome, Cognome, Stazione)
 DROP TABLE IF EXISTS `Operatore`;
CREATE TABLE `Operatore` (
			Matricola int NOT NULL auto_increment, 		
            Nome char(100) NOT NULL,
            Cognome char(100) NOT NULL,
			Stazione int,													
            PRIMARY KEY (Matricola),
            FOREIGN KEY (Stazione) REFERENCES Stazione(NStazione)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment =1;
 
 -- LINEA DI ASSEMBLAGGIO (CodLinea, Sequenza, TempoLimite)
 DROP TABLE IF EXISTS `LineaAssemblaggio`;
CREATE TABLE `LineaAssemblaggio` (
			CodLinea int NOT NULL auto_increment, 						
			Sequenza int DEFAULT NULL,
            TempoLimite int NOT NULL DEFAULT 0,							-- (epresso in minuti)  tempo massimo che l'operatore ha a disp. per eseguire le operazione in una stazione. Questo tempo è uguale in tutte le stazioni della linea
            PRIMARY KEY (CodLinea)					
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment =1;
 
 -- SUCCESSIONE (Linea, Operazione)
 DROP TABLE IF EXISTS `Successione`;
 CREATE TABLE `Successione` (
			Linea int NOT NULL,
            Operazione int NOT NULL,
            Ordine int NOT NULL,
            PRIMARY KEY (Linea, Operazione, Ordine),
            FOREIGN KEY (Linea) REFERENCES LineaAssemblaggio(CodLinea),
            FOREIGN KEY (Operazione) REFERENCES Operazione(CodOperazione)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
   
 -- LOTTO (CodLotto, SedeProduzione,  DataProduzione, DurataPreventivata, DurataEffettiva, Linea)
DROP TABLE IF EXISTS `Lotto`;
CREATE TABLE `Lotto` (
			CodLotto int NOT NULL auto_increment, 						
            SedeProduzione char(100) NOT NULL,
            DataProduzione date,		
            DurataPreventiva int NOT NULL,			-- quanto doveva durare la produzione  (espresso in ore)
            DurataEffettiva int,								-- quanto è durata (va calcolata con durata preventiva + l'operazione sulle unità perse)  (espresso in ore)
            Linea int NOT NULL,
            PRIMARY KEY (CodLotto),
            FOREIGN KEY (Linea) REFERENCES LineaAssemblaggio(CodLinea)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- MAGAZZINO (CodMagazzino, Capienza, Predisposizione)
 DROP TABLE IF EXISTS `Magazzino`;
CREATE TABLE `Magazzino` (
			CodMagazzino int NOT NULL auto_increment, 	
            Capienza int NOT NULL,											-- espressa in metri quadri
            Predisposizione char(100) NOT NULL,
            PRIMARY KEY (CodMagazzino)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- AREA (CodArea, Prodotto, Magazzino)
DROP TABLE IF EXISTS `Area`;
CREATE TABLE `Area` (
			CodArea int NOT NULL auto_increment,
            Prodotto char(100) NOT NULL,					-- che tipo di prodotto è depositato in quell'area (un prodotto x area) (controllare che siano coerenti con i tipi di prodotto che abbiamo nell'attributo Tipo di Prodotto)
			Magazzino int NOT NULL, 			
            PRIMARY KEY (CodArea),
            FOREIGN KEY (Magazzino) REFERENCES Magazzino(CodMagazzino)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- DEPOSITO (Area, Lotto)
DROP TABLE IF EXISTS `Deposito`;
CREATE TABLE `Deposito` (
            Area int NOT NULL,						
            Lotto int NOT NULL,
            PRIMARY KEY (Area, Lotto),					
			FOREIGN KEY (Area) REFERENCES Area(CodArea),
            FOREIGN KEY (Lotto) REFERENCES Lotto(CodLotto)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*--------------------------------------------------------------AREA VENDITE------------------------------------------------------------------------------*/

-- UTENTE (CodFiscale, Nome, Cognome, Telefono, DataIscrizione, Documento)
 DROP TABLE IF EXISTS `Utente`;
CREATE TABLE `Utente` (
			CodFiscale char(100) NOT NULL, 
            Nome char(100) NOT NULL,
            Cognome char(100) NOT NULL,
            Telefono int NOT NULL,
            DataIscrizione date NOT NULL,
            Documento int NOT NULL,			-- codice doc
            PRIMARY KEY (CodFiscale),
            FOREIGN KEY (Documento) REFERENCES Documento(NDocumento)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- DOMICILIO (Utente, Regione, Città, Provincia, Via, NumCivico)
 DROP TABLE IF EXISTS `Domicilio`;
 CREATE TABLE `Domicilio` (
			Utente char(100) NOT NULL,
            Regione char(100) NOT NULL,
            Citta char(100) NOT NULL,
            Provincia char(100) NOT NULL,
            Via char(100) NOT NULL,
            NumCivico char(10),								-- ci possono essere anche delle lettere ( es. 5b)
            PRIMARY KEY (Regione, Citta, Provincia, Via, NumCivico),
            FOREIGN KEY (Utente) REFERENCES Utente(CodFiscale)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- DOCUEMNTO DI RICONOSCIMENTO (NDocumento, Tipologia, Scandeza, EnteRilascio)
 DROP TABLE IF EXISTS `Documento`;
CREATE TABLE `Documento` (
			NDocumento int NOT NULL, 
            Tipologia char(100) NOT NULL,					
            Scadenza date NOT NULL,
            EnteRilascio char(100) NOT NULL,			
            PRIMARY KEY (NDocumento)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

 -- ACCOUNT (NomeUtente, Password, Risposta, DomandaSicurezza, Utente)
  DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
			NomeUtente char(100) NOT NULL, 
            `Password` char(100) NOT NULL,				
            Risposta char(100) NOT NULL,
            DomandaSicurezza char(255) NOT NULL,
            Utente char(100) NOT NULL,
            PRIMARY KEY (NomeUtente),
			FOREIGN KEY (Utente) REFERENCES Utente(CodFiscale)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

 -- ORDINE (CodOrdine, IstanteOrdine, StatoOrdine, Indirizzo, Cliente)
DROP TABLE IF EXISTS `Ordine`;
CREATE TABLE `Ordine` (
			CodOrdine int NOT NULL auto_increment, 						 	
            IstanteOrdine datetime NOT NULL,					
            StatoOrdine char(100) NOT NULL,				-- (va inserito il dominio) -> {in processazione, in preparazione, spedito, evaso, pendente}
            Indirizzo char(100),										-- può essere un indirizzo diverso da quello di residenze, se null si spedisce a quello di residenza
            Cliente char(100) NOT NULL,
            PRIMARY KEY (CodOrdine),
            FOREIGN KEY (Cliente) REFERENCES `Account`(NomeUtente)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- SPEDIZIONE (CodSpedizione, DataConsegnaPrevista, DataConsegnaEffettiva, StatoSpedizione, Ordine)
DROP TABLE IF EXISTS `Spedizione`;
CREATE TABLE `Spedizione` (
			CodSpedizione int NOT NULL auto_increment, 						 	
            DataConsegnaPrevista date NOT NULL,
            DataConsegnaEffettiva date,
			StatoSpedizione char(100) NOT NULL,  							-- inserire dominio -> {Spedita, in transito, In consegna, Consegnata}
            Ordine int NOT NULL,
            PRIMARY KEY (CodSpedizione),
            FOREIGN KEY (Ordine) REFERENCES Ordine(CodOrdine)   
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- HUB (NomeHub, Indirizzo)
DROP TABLE IF EXISTS `Hub`;
CREATE TABLE `Hub` (
			NomeHub char(100) NOT NULL , 						 	
            Indirizzo char(100) NOT NULL,
            PRIMARY KEY (NomeHub)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- PERCORSO (Spedizione, Hub, Tappa)
DROP TABLE IF EXISTS `Percorso`;
CREATE TABLE `Percorso` (
 			Spedizione int NOT NULL, 
            Hub char(100) NOT NULL,
            Tappa int NOT NULL,									
            PRIMARY KEY (Spedizione, Hub),
            FOREIGN KEY (Spedizione) REFERENCES Spedizione(CodSpedizione),
			FOREIGN KEY (Hub) REFERENCES Hub(NomeHub)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
 
 -- ACQUISTO (Prodotto, Ordine)		------------------- relazione tra Prodotto e Ordine
 DROP TABLE IF EXISTS `Acquisto`;
CREATE TABLE `Acquisto` (
 			Prodotto int NOT NULL,
            Ordine int NOT NULL, 
            PRIMARY KEY (Prodotto, Ordine),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
			FOREIGN KEY (Ordine) REFERENCES Ordine(CodOrdine)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1; 
 
 -- RECENSIONE (CodRecensione, EsperienzaUso, Affidabilità, Performance, CampoTestuale, Prodotto)
DROP TABLE IF EXISTS `Recensione`;
CREATE TABLE `Recensione` (
		   CodRecensione int NOT NULL auto_increment, 						 	
           EsperienzaUso int NOT NULL,									-- tutti e 3 gli attr vanno giudicati con un voto da 1 a 5
           Affidabilita int NOT NULL,								
           Performance int NOT NULL,
           CampoTestuale char(255),
           Prodotto int NOT NULL,
		   PRIMARY KEY (CodRecensione),
           FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- RESO (Prodotto, RichiestaAccettata, Ricondizionato, CostoRicondizionato, Motivazione, Modifica)
DROP TABLE IF EXISTS `Reso`;
CREATE TABLE `Reso` (
			Prodotto int NOT NULL, 						
            RichiestaAccettata char(100) NOT NULL,					-- si o no
            Ricondizionato char(100) DEFAULT NULL,							-- si o no
		    CostoRicondizionato double DEFAULT NULL,					-- espresso in euro
            Motivazione int NOT NULL,						-- codice motivazione
            Modifica int,											-- codice modifica
            PRIMARY KEY (Prodotto),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
			FOREIGN KEY (Motivazione) REFERENCES Motivazione(CodMotivazione),
            FOREIGN KEY (Modifica) REFERENCES Modifica(CodModifica)

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- MOTIVAZIONE (CodMotivazione, Nome, Descrizione)
 DROP TABLE IF EXISTS `Motivazione`;
CREATE TABLE `Motivazione` (
			CodMotivazione int NOT NULL auto_increment, 						 	
            Nome char(100) NOT NULL,							-- tipo di motivazione ( difetto estetico, funzionale, insoddisfazione)
            Descrizione char(255),
            PRIMARY KEY (CodMotivazione)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- GARANZIA (CodGaranzia, InizioGaranzia, DurataGaranzia)
  DROP TABLE IF EXISTS `Garanzia`;
CREATE TABLE `Garanzia` (
			CodGaranzia int NOT NULL auto_increment, 
            InizioGaranzia date DEFAULT NULL,					-- deve coincidere con la data di arrivo del prodotto? SI (vincolo generico)				è null all'inizio, quando il pacco viene consegnato inizia la garanzia
            DurataGaranzia int DEFAULT 24,					-- espressa in mesi
            PRIMARY KEY (CodGaranzia)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- FORMULA (CodFormula, Costo, MesiAggiuntivi, Descrizione)
   DROP TABLE IF EXISTS `Formula`;
CREATE TABLE `Formula` (
			CodFormula int NOT NULL auto_increment, 						
            Costo double NOT NULL,
            MesiAggiuntivi int NOT NULL,					-- espressa in mesi
            Descrizione char(100) NOT NULL,				-- descrizione della formula
            PRIMARY KEY (CodFormula)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- ESTENSIONE (Garanzia, Formula)
DROP TABLE IF EXISTS `Estensione`;
CREATE TABLE `Estensione` (
			Garanzia int NOT NULL, 
            Formula int NOT NULL,
            PRIMARY KEY (Garanzia, Formula),
            FOREIGN KEY (Garanzia) REFERENCES Garanzia(CodGaranzia),
            FOREIGN KEY (Formula) REFERENCES Formula(CodFormula)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- CLASSE DI GUASTI (CodGuasto, Descrizione)
DROP TABLE IF EXISTS `ClasseGuasti`;
CREATE TABLE `ClasseGuasti` (
			Tipologia char(100) NOT NULL, 			
            Descrizione char(100),							-- descrive la classe 
            PRIMARY KEY (Tipologia)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- TUTELA (Formula, ClasseGuasto)
 DROP TABLE IF EXISTS `Tutela`;
CREATE TABLE `Tutela` (
			Formula int NOT NULL, 						 
            ClasseGuasti int NOT NULL,
            PRIMARY KEY (Formula, ClasseGuasti),
            FOREIGN KEY (Formula) REFERENCES Formula(CodFormula),
            FOREIGN KEY (ClasseGuasti) REFERENCES ClasseGuasto(Tipologia)		
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 /*----------------------------------------------------------------------- AREA ASSISTENZA ------------------------------------------------------------------------------*/
 
 -- GUASTO (CodGuasto, Nome, Descrizione, Prodotto, Domanda)
 DROP TABLE IF EXISTS `Guasto`;
 CREATE TABLE `Guasto` (
			CodGuasto int NOT NULL auto_increment,					
            Nome char(100) NOT NULL,
            Descrizione char(255) NOT NULL,
            Prodotto int NOT NULL,					-- codice pordotto
            Domanda Int ,					-- codice domanda
            PRIMARY KEY (CodGuasto),
            FOREIGN KEY (Prodotto) REFERENCES Prodotto(CodSeriale),
            FOREIGN KEY (Domanda) REFERENCES Domanda(CodDomanda)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- ERRORE (CodErrore, TestoWarning, Guasto)																
 DROP TABLE IF EXISTS `Errore`;					
 CREATE TABLE `Errore` (
			CodErrore int NOT NULL auto_increment,					
            TestoWarning char(255) NOT NULL,
            Guasto int NOT NULL,
            PRIMARY KEY (CodErrore),
            FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- DOMANDA (CodDomanda, Testo, Rimedio)
  DROP TABLE IF EXISTS `Domanda`;					
 CREATE TABLE `Domanda` (
			CodDomanda int NOT NULL auto_increment,				
            Testo char(255) NOT NULL,
            Rimedio int NOT NULL,							-- codice rimedio
            PRIMARY KEY (CodDomanda),
			FOREIGN KEY (Rimedio) REFERENCES Rimedio(CodRimedio)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- SEQUENZA DOMANDE (Attuale, Successiva)
  DROP TABLE IF EXISTS `Risposta`;
 CREATE TABLE `Risposta` (
			Attuale int NOT NULL,		-- codice domanda Attuale			
            Successiva int ,		-- codice domanda successiva
            PRIMARY KEY (Attuale, Successiva),
            FOREIGN KEY (Attuale) REFERENCES Domanda(CodDomanda),
            FOREIGN KEY (Successiva) REFERENCES Domanda(CodDomanda)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
-- RIMEDIO (CodRimedio, Descrizione)
  DROP TABLE IF EXISTS `Rimedio`;					
 CREATE TABLE `Rimedio` (
			CodRimedio int NOT NULL auto_increment,		
            Descrizione char(255) NOT NULL,
            PRIMARY KEY (CodRimedio)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- AUTORIPARAZIONE (Errore, Rimedio)
 DROP TABLE IF EXISTS `Autoriparazione`;
 CREATE TABLE `Autoriparazione` (
			Errore int NOT NULL,					
            Rimedio int NOT NULL,
            PRIMARY KEY (Errore, Rimedio),
            FOREIGN KEY (Errore) REFERENCES Errore(CodErrore),
            FOREIGN KEY (Rimedio) REFERENCES Rimedio(CodRimedio)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 -- INTERVENTO (CodIntervento, Orario, OreLavoro, Guasto, Tecnico)
DROP TABLE IF EXISTS `Intervento`;					
CREATE TABLE `Intervento` (
			CodIntervento int NOT NULL auto_increment,					
			Orario datetime NOT NULL,					
            OreLavoro double NOT NULL,			-- espresso in ore
            Guasto int NOT NULL,				-- codice del guasto
            Tecnico int,				-- matricola del tecnico
            PRIMARY KEY (CodIntervento),
            FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto),
			FOREIGN KEY (Tecnico) REFERENCES Tecnico(Matricola)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- RICEVUTA (CodRicevuta, ModPagamento, Costo, Intervento)
 DROP TABLE IF EXISTS `Ricevuta`;					
CREATE TABLE `Ricevuta` (
			CodRicevuta int NOT NULL auto_increment,				
            ModPagamento char(100) NOT NULL,						-- {visa, mastercard, paypal}
            Costo double NOT NULL,
            Intervento int NOT NULL,					-- codice intervento
            PRIMARY KEY (CodRicevuta),
            FOREIGN KEY (Intervento) REFERENCES Intervento(CodIntervento)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- PREVENTIVO (CodPreventivo, Accettato, CostoPreventivo, Intervento)
DROP TABLE IF EXISTS `Preventivo`;					
CREATE TABLE `Preventivo` (
			CodPreventivo int NOT NULL auto_increment,				
            Accettato char(100) NOT NULL,
            CostoPreventivo double NOT NULL,
            Intervento int NOT NULL,					-- codice intervento
            PRIMARY KEY (CodPreventivo),
            FOREIGN KEY (Intervento) REFERENCES Intervento(CodIntervento)            
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- ORDINE PEZZI RICAMBIO (CodOrdine, DataOrdine, DataPrevistaConsegna, DataEffettivaConsegna, Intervento)
 DROP TABLE IF EXISTS `OrdinePezziRicambio`;	
CREATE TABLE `OrdinePezziRicambio` (
			CodOrdine int NOT NULL auto_increment,				
            DataOrdine date NOT NULL,
            DataPrevistaConsegna date NOT NULL,
            DataEffettivaConsegna date NOT NULL,
            Intervento int NOT NULL,					-- codice intervento
            PRIMARY KEY (CodOrdine),
            FOREIGN KEY (Intervento) REFERENCES Intervento(CodIntervento)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- PEZZI RICAMBIO (CodPezzo, Nome, Costo)					
DROP TABLE IF EXISTS `PezzoRicambio`;					
CREATE TABLE `PezzoRicambio` (
			CodPezzo int NOT NULL auto_increment,				
            Nome char(100) NOT NULL,			
            Costo double NOT NULL,
            PRIMARY KEY (CodPezzo)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- RICHIESTA (Ordine, Pezzo, Quantita)
DROP TABLE IF EXISTS `Richiesta`;
 CREATE TABLE `Richiesta` (
			Ordine int NOT NULL,					
             Pezzo int NOT NULL,
             Quantita int NOT NULL,
            PRIMARY KEY (Ordine, Pezzo),
            FOREIGN KEY (Ordine) REFERENCES OrdinePezziRicambio(CodOrdine),
            FOREIGN KEY (Pezzo) REFERENCES PezzoRicambio(CodPezzo)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
 
 -- TECNICO (Matricola, Nome, Cognome, TariffaOraria, Regione, Provincia)
 DROP TABLE IF EXISTS `Tecnico`;					
CREATE TABLE `Tecnico` (
			Matricola int NOT NULL auto_increment,				
            Nome char(100) NOT NULL,
			Cognome char(100) NOT NULL,
            TariffaOraria double NOT NULL,
            Regione char(100) NOT NULL,							-- regione del tecnico
            Provincia char(100) NOT NULL, 						-- provincia dove opera il tecnico  		
			PRIMARY KEY (Matricola)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

-- CENTRO ASSISTENZA (CodCentro, Nome, Indirizzo)
 DROP TABLE IF EXISTS `CentroAssistenza`;					
CREATE TABLE `CentroAssistenza` (
			CodCentro int NOT NULL auto_increment,		
            Nome char(100) NOT NULL,
            Indirizzo char(100) NOT NULL,					
			PRIMARY KEY (CodCentro)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;
 
 -- AFFERENZA (Tecnico, Centro)
  DROP TABLE IF EXISTS `Afferenza`;
 CREATE TABLE `Afferenza` (
			Tecnico int NOT NULL,					
			 Centro int NOT NULL,
            PRIMARY KEY (Tecnico, Centro),
            FOREIGN KEY (Tecnico) REFERENCES Tecnico(Matricola),
            FOREIGN KEY (Centro) REFERENCES CentroAssistenza(CodCentro)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ORARIO (CodOrario, Data, OraInizio, OraFine)
 DROP TABLE IF EXISTS `Orario`;					
CREATE TABLE `Orario` (
			CodOrario int NOT NULL auto_increment,
			`Data` date NOT NULL,					
            OraInizio time NOT NULL,
            OraFine time NOT NULL,
			PRIMARY KEY (CodOrario)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1 auto_increment=1;

 -- DISPONIBILITA' (Tecnico,CodOrario)
   DROP TABLE IF EXISTS `Disponibilita`;
 CREATE TABLE `Disponibilita` (
			Tecnico int NOT NULL,					
			CodOrario int NOT NULL,
            PRIMARY KEY (Tecnico, CodOrario),
            FOREIGN KEY (Tecnico) REFERENCES Tecnico(Matricola),
            FOREIGN KEY (CodOrario) REFERENCES Orario(CodOrario)
 )	ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
/*------------------------------------------------------------------------------- AREA SMONTAGGIO ------------------------------------------------------------------------------ */

-- MODIFICA (CodModifica, Descrizione, PercentualeAumentoCosto)
DROP TABLE IF EXISTS `Modifica`;
CREATE TABLE `Modifica` (
CodModifica int NOT NULL AUTO_INCREMENT,
Descrizione char(255) NOT NULL,
PercentualeAumentoCosto double NOT NULL, -- espressa in percentuale
PRIMARY KEY (CodModifica)
) ENGINE=InnoDB DEFAULT CHARSET=latin1, AUTO_INCREMENT = 1;

-- TEST (Codice, Nome, Livello, Successo, PercentualeFallimento, SogliaTest)
DROP TABLE IF EXISTS `Test`;
CREATE TABLE `Test` (
Codice int NOT NULL,
Nome char(100) NOT NULL,
Livello int NOT NULL,
Successo char(100) NOT NULL,
PercentualeFallimento double NOT NULL,
SogliaTest double NOT NULL,
PRIMARY KEY (Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- VERIFICA (Reso, Test, Esito)
DROP TABLE IF EXISTS `Verifica`;
CREATE TABLE `Verifica` (
Reso int NOT NULL,
Test int NOT NULL,
Esito char(100),
PRIMARY KEY (Reso, Test),
FOREIGN KEY (Reso) REFERENCES Reso(Prodotto), -- non so se la chiave di reso è questa
FOREIGN KEY (Test) REFERENCES Test(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- SEQUENZA TEST (TestPrecedente, TestSuccessivo)
DROP TABLE IF EXISTS `SequenzaTest`;
CREATE TABLE `SequenzaTest` (
TestPrecedente int NOT NULL,
TestSuccessivo int ,
PRIMARY KEY (TestPrecedente, TestSuccessivo),
FOREIGN KEY (TestPrecedente) REFERENCES Test(Codice),
FOREIGN KEY (TestSuccessivo) REFERENCES Test(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- PARTE SOTTOPOSTA A TEST (CodParte)
DROP TABLE IF EXISTS `ParteSottoTest`;
CREATE TABLE `ParteSottoTest` (
CodParte int NOT NULL,
PRIMARY KEY (CodParte)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CONTROLLO (Parte, Test)
DROP TABLE IF EXISTS `Controllo`;
CREATE TABLE `Controllo` (
Parte int NOT NULL,
Test int NOT NULL,
PRIMARY KEY (Parte, Test),
FOREIGN KEY (Parte) REFERENCES ParteSottoTest(CodParte),
FOREIGN KEY (Test) REFERENCES Test(Codice)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*--------------------------------------------------------------TABELLE PER LE OPERAZIONI---------------------------------------------------------------*/

DROP TABLE IF EXISTS Carrello;
CREATE TABLE IF NOT EXISTS Carrello(
	NomeUtente CHAR(100),
    Tipo CHAR(100),
    Marca CHAR(100),
    Modello CHAR(100),
    Quantita INT,
    PRIMARY KEY(NomeUtente, Tipo, Marca, Modello)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS ProdottoPendente;
CREATE TABLE IF NOT EXISTS ProdottoPendente (
	CodOrdine INT PRIMARY KEY,
	Tipo CHAR(100),
	Marca CHAR(100),
	Modello CHAR(100),
	Quantita INT,
	Evaso CHAR(2) DEFAULT 'no'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS ProdottiPersi;
CREATE TABLE IF NOT EXISTS ProdottiPersi (
	Prodotto INT PRIMARY KEY,
	Tempo INT
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS StatisticheOperatore;
CREATE TABLE IF NOT EXISTS StatisticheOperatore (
	Operatore INT NOT NULL,
    Operazione INT NOT NULL,
    TempoMedio INT,
    PRIMARY KEY (Operatore, Operazione),
    FOREIGN KEY (Operatore) REFERENCES Operatore(Matricola),
    FOREIGN KEY (Operazione) REFERENCES Operazione(CodOperazione)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS EfficienzaStazioni;
CREATE TABLE IF NOT EXISTS EfficienzaStazioni (
	Linea INT NOT NULL,
    Stazione INT NOT NULL PRIMARY KEY,
    InefficienzaOperatori DOUBLE,
    OperatoriInefficienti CHAR(255),
    TempoPerso INT DEFAULT 0
);

DROP TABLE IF EXISTS EfficienzaProduzione;
CREATE TABLE IF NOT EXISTS EfficienzaProduzione (
	Linea INT NOT NULL PRIMARY KEY,
    NStazioni INT NOT NULL,
    StazioniInefficienti CHAR(255) DEFAULT '',
    OperatoriInefficienti CHAR(255) DEFAULT '',
    PercentualeResi DOUBLE DEFAULT 0,
	Inefficienza DOUBLE,
    TempoPerso INT NOT NULL,
    TempoPersoMedio INT NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Sintomi;
CREATE TABLE IF NOT EXISTS Sintomi (
	Guasto INT NOT NULL,
    Sintomo	INT NOT NULL,
    PRIMARY KEY(Guasto, Sintomo)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS Soluzioni;
CREATE TABLE IF NOT EXISTS Soluzioni (
	Guasto INT NOT NULL,
    Rimedio	INT NOT NULL,
    PRIMARY KEY(Guasto, Rimedio)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS ReportVendite;
-- Creo la tabella del report vendite
CREATE TABLE IF NOT EXISTS ReportVendite (
	Tipo CHAR(100),
	Marca CHAR(100),
	Modello CHAR(100),
	Venduti INT DEFAULT 0,
	PRIMARY KEY (Tipo, Marca, Modello)
);

-- Creo la tabella del report ordini pendenti
DROP TABLE IF EXISTS ReportProdottiPendenti;
CREATE TABLE IF NOT EXISTS ReportProdottiPendenti (
	Tipo CHAR(100),
	Marca CHAR(100),
	Modello CHAR(100),
	Pendenti INT DEFAULT 0,
	PRIMARY KEY (Tipo, Marca, Modello)
);

DROP TABLE IF EXISTS NuoviSintomi;    
CREATE TABLE IF NOT EXISTS NuoviSintomi (
	Guasto INT DEFAULT NULL,
	Sintomo INT NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS RimediUtilizzati;    
CREATE TABLE IF NOT EXISTS RimediUtilizzati (
	Guasto INT DEFAULT NULL,
	Rimedio INT NOT NULL PRIMARY KEY
);
/*---------------------------------------------------------------------TRIGGER---------------------------------------------------------------------------------*/
-- Se la motivazione di reso è "Diritto di Recesso', il reso viene accettato
DROP TRIGGER IF EXISTS DirittoRecesso;
DELIMITER $$
CREATE TRIGGER DirittoRecesso
BEFORE INSERT ON Reso FOR EACH ROW
BEGIN
	DECLARE _Motivazione CHAR(100);
    
    SELECT M.Nome INTO _Motivazione
    FROM Motivazione M
    WHERE NEW.Motivazione = M.CodMotivazione;
    
	IF (_Motivazione = 'Diritto di Recesso') THEN
		SET NEW.RichiestaAccettata = 'si';
	END IF;
END $$



-- Quando viene inserita una nuova spedizione, lo stato dell'ordine corrispondente passa a 'Spedito'
DROP TRIGGER IF EXISTS SpedizioneProdotto;
DELIMITER $$
CREATE TRIGGER SpedizioneProdotto
AFTER INSERT ON Spedizione FOR EACH ROW
BEGIN
	UPDATE Ordine
    SET StatoOrdine = 'Spedito'
    WHERE CodOrdine = NEW.Ordine;
END $$
DELIMITER ;



-- Quando un prodotto viene consegnato, lo stato dell'ordine corrispondente passa a 'Consegnato'
DROP TRIGGER IF EXISTS ConsegnaProdotto;
DELIMITER $$
CREATE TRIGGER ConsegnaProdotto
AFTER UPDATE ON Spedizione FOR EACH ROW
BEGIN
	DECLARE _Stato CHAR (50);
	UPDATE Ordine
    SET StatoOrdine = 'Consegnato'
    WHERE CodOrdine = NEW.Ordine;
    
    -- La Data di Inizio Garanzia viene posta uguale alla data di consegna
    UPDATE Garanzia
    SET InizioGaranzia = NEW.DataConsegnaEffettiva
    WHERE CodGaranzia IN (SELECT P.Garanzia
						  FROM Spedizione S INNER JOIN Ordine O ON S.Ordine = O.CodOrdine
							INNER JOIN Acquisto A ON O.CodOrdine = A.Ordine
                            INNER JOIN Prodotto P ON A.Prodotto = P.CodSeriale
						  WHERE S.CodSpedizione = NEW.CodSpedizione);
    
    -- Controllo lo stato del prodotto
	SELECT P.Stato INTO _Stato
    FROM Spedizione S INNER JOIN Ordine O ON S.Ordine = O.CodOrdine
		INNER JOIN Acquisto A ON O.CodOrdine = A.Ordine
		INNER JOIN Prodotto P ON A.Prodotto = P.CodSeriale
	WHERE S.CodSpedizione = NEW.CodSpedizione;
    
    -- Se è ricondizionato la durata della garanzia è di 6 mesi
    IF _Stato = 'Ricondizionato' THEN
		UPDATE Garanzia
		SET DurataGaranzia = 6
		WHERE CodGaranzia IN (SELECT P.Garanzia
							  FROM Spedizione S INNER JOIN Ordine O ON S.Ordine = O.CodOrdine
								INNER JOIN Acquisto A ON O.CodOrdine = A.Ordine
								INNER JOIN Prodotto P ON A.Prodotto = P.CodSeriale
						      WHERE S.CodSpedizione = NEW.CodSpedizione);
	END IF;
END $$



-- Il tempo medio di una stazione deve essere uguale alla somma dei tempi medi delle operazioni a essa assegnate
DROP TRIGGER IF EXISTS TempoMedioStazione;
DELIMITER $$
CREATE TRIGGER TempoMedioStazione
AFTER INSERT ON Assegnamento FOR EACH ROW
BEGIN
	DECLARE _SommaTempiMedi INT DEFAULT 0;
    
    SELECT SUM(O.TempoMedio) INTO _SommaTempiMedi
    FROM Assegnamento A INNER JOIN Operazione O ON A.Operazione = O.CodOperazione
    WHERE A.Stazione = NEW.Stazione;
    
	UPDATE Stazione
    SET TempoMedio = _SommaTempiMedi
    WHERE NStazione = NEW.Stazione;
END $$
DELIMITER ;



-- Quando assegno un tecnico ad un intervento cancella la prima disponibilita del tecnico
DROP TRIGGER IF EXISTS EliminaDisponibilita;
CREATE TRIGGER EliminaDisponibilita
AFTER UPDATE ON Intervento
FOR EACH ROW

-- cancello la disponibilita del tecnico che ho assegnarlo all'intervento
DELETE FROM Disponibilita D
WHERE D. Tecnico = NEW.Tecnico
LIMIT 1;



-- Creazione dell'event x la funzionalità Assegnamento Tecnici
DROP EVENT IF EXISTS AssegnaTecnici;
CREATE EVENT AssegnaTecnici
ON SCHEDULE EVERY 1 WEEK
DO
CALL AssegnamentoTecnici();



-- creo trigger che quando inseriamo su esito 'positivo' aggiorna il record di ricondizionato e lo mette a 'si'
DROP TRIGGER IF EXISTS AggiornaRicondizionato;
DELIMITER $$
CREATE TRIGGER AggiornaRicondizionato
AFTER UPDATE ON Verifica FOR EACH ROW
BEGIN
	DECLARE _Costo double DEFAULT 0;
    
		SELECT Costo INTO _Costo
        FROM Prodotto
        WHERE CodSeriale = NEW.Reso;
        
-- controllo che l'esito dei test sia risultato positivo e metto ricondizionato a 'Si' e metto il costo de ric. con il 30% di sconto rispetto al prodotto nuovo
	IF NEW.Esito = 'Positivo' THEN
		UPDATE Reso
        SET Ricondizionato = 'Si' 
        WHERE Prodotto = NEW.Reso;
        
        UPDATE Reso
        SET CostoRicondizionato = _Costo - (_Costo * 0.3)
        WHERE Prodotto = NEW.Reso;
        
	-- faccio la chiamata alla procedura
        CALL ControlloCostiRicondizionati(NEW.Reso, @controllo);
        
	END IF;
END $$
DELIMITER ;



-- Creo l'event settiminale per l'analisi
DROP EVENT IF EXISTS Report;
DELIMITER $$
CREATE EVENT Report
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
	CALL Analisi();
    
    SELECT *
	FROM ReportVendite;
    
	SELECT *
	FROM ReportProdottiPendenti;
END $$	
DELIMITER ;



-- Quando viene inserito un nuovo tempo nella tab StatisticheOperatore, viene fatta la media di tutti i tempi relativi a quell'operazione
DROP TRIGGER IF EXISTS TempoMedioOperazioni;
DELIMITER $$
CREATE TRIGGER TempoMedioOperazioni
AFTER INSERT ON StatisticheOperatore FOR EACH ROW
BEGIN
	DECLARE _TempoMedio INT;
    
    SELECT ROUND(AVG(TempoMedio)) INTO _TempoMedio
    FROM StatisticheOperatore
    WHERE Operazione = NEW.Operazione;
    
    UPDATE Operazione
    SET TempoMedio = _TempoMedio
    WHERE CodOperazione = NEW.Operazione;
END $$
DELIMITER ;

/*---------------------------------------------------------FUNZIONALITA' LATO SERVER-------------------------------------------------------------------*/
-- Controllo se la sequenza inserita è valida
DROP PROCEDURE IF EXISTS ValidazioneSequenza;
DELIMITER $$
CREATE PROCEDURE ValidazioneSequenza(IN _CodLinea INT, _Sequenza INT)
BEGIN
	DECLARE finito INT DEFAULT 0;
    DECLARE valida INT DEFAULT 1;
    DECLARE _FacciaOperazione CHAR(100);
    DECLARE _FacciaAppoggio CHAR(100);
    DECLARE _FAcciaAppoggioPrec CHAR(100) DEFAULT NULL;
    DECLARE _Ranking INT;
    DECLARE _RankingPrec INT DEFAULT 0;
    DECLARE _NStazione INT;
    DECLARE _NStazionePrec INT DEFAULT 0;
    DECLARE _TempoLimite INT DEFAULT 0;
    
    DECLARE Cursore CURSOR FOR
    SELECT O.Faccia, S.OrientamentoProdotto, ASS.Ranking, S.NStazione
    FROM Stazione S INNER JOIN LineaAssemblaggio LA ON S.Linea = LA.CodLinea
		INNER JOIN Assegnamento A ON S.NStazione = A.Stazione
        INNER JOIN Operazione O ON A.Operazione = O.CodOperazione
        INNER JOIN Assemblaggio ASS ON O.CodOperazione = ASS.Operazione
	WHERE LA.CodLinea = _CodLinea
    ORDER BY S.Ordinamento, A.Ranking;
    
    DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
	OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _FacciaOperazione, _FacciaAppoggio, _Ranking, _NStazione;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Se la faccia dell'operazione è uguale alla faccia di appoggio non va bene
        IF _FacciaOperazione = _FacciaAppoggio THEN
			SET valida = 0;
            LEAVE preleva;
		END IF;
        
        -- Se il prodotto viene ruotato all'interno di una stazione non va bene
        IF _NStazione = _NStazionePrec AND _FacciaAppoggio <> _FacciaAppoggioPrec THEN
			SET valida = 0;
            LEAVE preleva;
		END IF;
        
        -- Se non è rispettato il vincolo di precedenza tecnologica non va bene
        IF _Ranking < _RankingPrec THEN
			SET valida = 0;
            LEAVE preleva;
		END IF;
        
        SET _NStazionePrec = _Nstazione;
        SET _FacciaAppoggioPrec = _FacciaAppoggio;
        SET _RankingPrec = _Ranking;
    END LOOP preleva;
    
    -- Se la sequenza non è valida
    IF valida = 0 THEN
		-- Si eliminano le operazioni assegnate alle stazioni della sequenza non valida
		DELETE FROM Assegnamento
        WHERE Stazione IN (SELECT NStazione
						   FROM Stazione
                           WHERE Linea = _CodLinea);
                           
		-- Si eliminano le stazioni assegnate alla linea con la sequenza non valida
        UPDATE Stazione
        SET Linea = NULL
        WHERE Linea = _CodLinea;
        
        SELECT 'Sequenza non valida';
	ELSE
		-- Inserisco l'associazione valida tra operazione e linea di assemblaggio
        INSERT INTO Successione
		SELECT S.Linea, A.Operazione, ROW_NUMBER() OVER ()
        FROM Stazione S INNER JOIN Assegnamento A ON S.NStazione = A.Stazione
		WHERE S.Linea = _CodLinea
        ORDER BY S.NStazione, A.Ranking;
        
        -- Calcolo il tempo limite della linea ponendolo uguale al 10% in più rispetto alla stazione col tempo medio massimo
        SELECT MAX(TempoMedio) INTO _TempoLimite
        FROM Stazione
        WHERE Linea = _CodLinea;
        
        SET _TempoLimite = _TempoLimite + 0.1*_TempoLimite;
        
        -- Inserisco la sequenza in Linea di Assemblaggio
        UPDATE LineaAssemblaggio
        SET Sequenza = _Sequenza,
			TempoLimite = _TempoLimite
        WHERE CodLinea = _CodLinea;
        SELECT 'Sequenza valida';
	END IF;
END $$
DELIMITER ;



-- INSERT per ValidazioneSequenza
INSERT INTO LineaAssemblaggio
VALUES();
INSERT INTO LineaAssemblaggio
VALUES();
INSERT INTO LineaAssemblaggio
VALUES();

INSERT INTO Stazione (OrientamentoProdotto, Linea, Ordinamento)
VALUES ('Schermo', 1, 1),
			   ('Lato DX', 1, 2),
               ('Inferiore', 2, 1),
			   ('Tastiera', 2, 2),
               ('Superiore', 3, 1),
			   ('Inferiore', 3, 2);


INSERT INTO Operatore (Nome, Cognome, Stazione)
VALUES('Linus', 'Torvalds', 1),
	('Ada', 'Lovelace', 2),
    ('George', 'Boole', 3),
    ('Larry', 'Page', 4),
    ('Mario', 'Rossi', 5),
    ('Maria', 'Verdi', 6);
    
    
INSERT INTO Operazione (Nome, Faccia)
VALUES ('Inserimento batteria', 'Retro'),
	('Collegamento circuiti', 'Retro'),
    ('Saldatura scocca', 'Retro'),
    ('Inserimento batteria', 'Inferiore'),
	('Collegamento circuiti', 'Schermo'),
    ('Saldatura scocca', 'Retro'),
    ('Inserimento fotocamera', 'Schermo'),
    ('Saldatura tubi', 'Retro'),
	('Inserimento Filtro', 'Retro'),
	('Inserimento cestello', 'Frontale'),
	('Aggancio oblo', 'Frontale');

-- Inserimento dei tempi che gli operatori impiegano per le varie operazioni
INSERT INTO StatisticheOperatore
VALUES(1, 1, 2),
	(2, 1, 3),
    (3, 1, 2),
    (4, 1, 5),
    (1, 2, 7),
    (2, 2, 15),
    (3, 2, 4),
    (4, 2, 6),
    (1, 3, 5),
    (2, 3, 3),
    (3, 3, 2),
    (4, 3, 3),
    (1, 4, 2),
    (2, 4, 2),
    (3, 4, 4),
    (4, 4, 3),
    (1, 5, 3),
    (2, 5, 5),
    (3, 5, 5),
    (4, 5, 6),
    (1, 6, 3),
    (2, 6, 2),
    (3, 6, 5),
    (4, 6, 4),
    (1, 7, 5),
    (2, 7, 6),
    (3, 7, 8),
    (4, 7, 7),
    (5, 1, 5),
    (5, 2, 4),
    (5, 3, 5),
    (5, 4, 6),
    (5, 5, 2),
    (5, 6, 4),
    (5, 7, 3),
    (6, 1, 4),
    (6, 2, 19),
    (6, 3, 7),
    (6, 4, 8),
    (6, 5, 4),
    (6, 6, 3),
    (6, 7, 5),
    (1, 8, 2),
	(2, 8, 3),
    (3, 8, 2),
    (4, 8, 5),
    (5, 8, 3),
    (6, 8, 4),
    (1, 9, 2),
	(2, 9, 3),
    (3, 9, 2),
    (4, 9, 5),
    (5, 9, 3),
    (6, 9, 4),
    (1, 10, 2),
	(2, 10, 3),
    (3, 10, 2),
    (4, 10, 5),
    (5, 10, 3),
    (6, 10, 4),
    (1, 11, 2),
	(2, 11, 3),
    (3, 11, 2),
    (4, 11, 5),
    (5, 11, 3),
    (6, 11, 4);
    
INSERT INTO Assegnamento
VALUES(1, 1, 1),
	(1, 2, 2),
    (2, 2, 1),
    (2, 3, 2),
    (3, 4, 1),
	(3, 5, 2),
    (3, 7, 3),
    (4, 6, 1),
    (5, 8, 1),
	(5, 9, 2),
	(6, 10, 1),
	(6, 11, 2);
            
INSERT INTO Parte (Nome, Peso, Prezzo, CoeffSvalutazione)
VALUES('Schermo telefono', 100, 60, 0),
			('Batteria', 60, 50, 0),
			('Ram 4GB', 20, 30, 0),
			('Porte I/O', 10, 20, 0),
            ('Schermo PC', 150, 200, 0),
			('Tastiera', 100, 50, 0),
			('Speaker', 100, 70, 0),
			('Ventola PC', 250, 100, 0),
            ('Cestello', 300, 50, 0),
			('oblo', 120, 40, 0),
            ('Filtro', 100, 120, 0),
            ('Tubo', 30, 20, 0);
            
INSERT INTO Assemblaggio
VALUES(1, 1, 1),
			(2, 1, 1),
			(2, 2, 2),
			(3, 2, 2),
			(3, 3, 3),
			(4, 3, 3),
            (5, 4, 1),
			(6, 4, 1),
			(6, 5, 2),
			(7, 5, 2),
			(7, 7, 3),
			(8, 6, 4),
            (11, 8, 1),
			(12, 8, 1),
            (12, 9, 2),
            (9, 9, 2),
            (9,10, 3),
            (10, 10, 3),
            (10, 11, 4);
            
CALL ValidazioneSequenza(1, 1);
CALL ValidazioneSequenza(2, 2);
CALL ValidazioneSequenza(3, 3);

-- Inserimento corretto della sequenza nella linea di assemblaggio 2
UPDATE Stazione
SET Linea = 2
WHERE NStazione = 3 OR NStazione = 4;

UPDATE Operazione
SET Faccia = 'Schermo'
WHERE CodOperazione = 4;
    
-- Assegnamento PC
INSERT INTO Assegnamento
VALUES(3, 4, 1),
	(3, 5, 2),
    (3, 7, 3),
    (4, 6, 1);
    
CALL ValidazioneSequenza(2, 4);




/*---------------------------------------------------------------------OPERAZIONE 1-----------------------------------------------------------------------*/
-- 1) Inserimento nuovo ordine
DROP PROCEDURE IF EXISTS NuovoOrdine;
DELIMITER $$
CREATE PROCEDURE NuovoOrdine(IN _NomeUtente CHAR(100), _Indirizzo CHAR(100))
BEGIN
	DECLARE finito INT DEFAULT 0;
    DECLARE _Tipo CHAR(100);
    DECLARE _Marca CHAR(100);
    DECLARE _Modello CHAR(100);
    DECLARE _Quantita INT;
    DECLARE _Conta INT;
    DECLARE _Ordine INT;
    DECLARE _Pendente CHAR(2) DEFAULT 'no';
    
    DECLARE Cursore CURSOR FOR
    SELECT C.Tipo, C.Marca, C.Modello, C.Quantita
    FROM Carrello C
    WHERE C.NomeUtente = _NomeUtente;
    
    DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    -- Si inserisce il nuovo ordine
    INSERT INTO Ordine (IstanteOrdine, StatoOrdine, Indirizzo, Cliente)
    VALUES(CURRENT_TIMESTAMP, 'In processazione', _Indirizzo, _NomeUtente);
    
    -- Si salva il valore autoincrementato dell'ordine in una variabile
    SET _Ordine = LAST_INSERT_ID();
	
    -- Si scorrono i prodotti del carrello
    OPEN Cursore; 
    preleva: LOOP
		FETCH Cursore INTO _Tipo, _Marca, _Modello, _Quantita;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Controllo se è disponibile l'intera quantità del prodotto richiesto
        SELECT COUNT(*) INTO _Conta
        FROM Prodotto P
        WHERE P.Tipo = _Tipo AND P.Marca = _Marca AND P.Modello = _Modello
			AND (P.Stato = 'Disponibile' OR P.Stato = 'Ricondizionato');
        
        -- Se i prodotti sono disponibili
        IF (_Conta >= _Quantita) THEN
			-- Inserisco il prodotto in Acquisto
			INSERT INTO Acquisto
            SELECT P.CodSeriale, _Ordine
			FROM Prodotto P
			WHERE P.Tipo = _Tipo AND P.Marca = _Marca AND P.Modello = _Modello
				AND (P.Stato = 'Disponibile' OR P.Stato = 'Ricondizionato')
			ORDER BY P.DataProduzione
            LIMIT _Quantita;
		ELSE
			-- Inserisco il prodotto nella tabella degli ordini pendenti
            INSERT INTO ProdottoPendente
            VALUES(_Ordine, _Tipo, _Marca, _Modello, _Quantita, 'no');
            
            -- Modifico lo stato ordine in "pendente"
            UPDATE Ordine
            SET StatoOrdine = 'Pendente'
            WHERE CodOrdine = _Ordine;
            SET _Pendente = 'si';
		END IF;
    END LOOP preleva;
    CLOSE Cursore;
    
    -- Aggiorno lo stato dei prodotti acquistati in "venduto"
    UPDATE Prodotto
    SET Stato = 'Venduto'
    WHERE CodSeriale IN (
		SELECT Prodotto
        FROM Acquisto
        WHERE Ordine = _Ordine
	);
    
    -- Se tutti i prodotti sono disponibili aggiorno lo stato dell'ordine in "In preparazione"
    IF _Pendente = 'no' THEN
		UPDATE Ordine
        SET StatoOrdine = 'In preparazione'
        WHERE CodOrdine = _Ordine;
        
        TRUNCATE TABLE Carrello;
	END IF;
END $$
DELIMITER ;



-- Inserimenti per nuovo ordine
INSERT INTO Documento
VALUES(1, 'CI', '2025-01-01', 'Comune'),
	(2, 'CI', '2024-09-01', 'Comune');

INSERT INTO Utente
VALUES('A1', 'Lorenzo', 'Barci', 098098, '2019-01-01', 1),
	('B2', 'Andrea', 'Rossi', 0101010, '2020-02-06', 2);

INSERT INTO Domicilio
VALUES('A1', 'Toscana', 'Pisa', 'PI', 'Via Ciao', '1'),
	('B2', 'Toscana', 'Firenze', 'FI', 'Via Salve', '1');

INSERT INTO `Account`
VALUES('Lore', 'AAA', 'B', 'Prima lettera del cognome?', 'A1'),
	('Andre', 'BBB', 'A', 'Prima lettera del nome?', 'B2');

INSERT INTO Lotto (SedeProduzione, DataProduzione, DurataPreventiva, DurataEffettiva, Linea)
VALUES('Pisa', '2021-02-01', 2, 1, 1),
	('Pisa', '2021-02-23', 3, 3, 2),
    ('Pisa', '2021-02-01', 3, 3, 1),
    ('Pisa', '2021-02-11', 3, 3, 2),
    ('Livorno', '2021-01-23', 3, 3, 3);

INSERT INTO Garanzia
VALUES(), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), (), ();

-- Lotti Smartphone
INSERT INTO Prodotto (Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia)
VALUES('Galaxy', 'Samsung', 'GT56', 'Smartphone', 2, 200, '2021-01-01', 0, 'Disponibile', 1, 1),
	('Galaxy', 'Samsung', 'GT56', 'Smartphone', 2, 200, '2021-01-01', 0, 'Disponibile', 1, 2),
    ('Galaxy', 'Samsung', 'GT56', 'Smartphone', 2, 200, '2021-01-01', 0, 'Disponibile', 1, 3),
    ('Note', 'Samsung', 'GA56', 'Smartphone', 2, 200, '2021-02-01', 0, 'Disponibile', 1, 4),
    ('Note', 'Samsung', 'GA56', 'Smartphone', 2, 200, '2021-02-01', 0, 'Disponibile', 1, 5),
    ('iPhone 10', 'Apple', 'A6', 'Smartphone', 2, 1200, '2021-02-01', 0, 'Disponibile', 3, 6),
    ('iPhone 10', 'Apple', 'A6', 'Smartphone', 2, 1200, '2021-02-01', 0, 'Disponibile', 3, 7),
    ('iPhone 10', 'Apple', 'A6', 'Smartphone', 2, 1200, '2021-02-01', 0, 'Disponibile', 3, 8);

-- Lotti PC
INSERT INTO Prodotto (Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia)
VALUES('Pavilion', 'HP', 'SP89', 'PC', 4, 700, '2021-01-23', 0, 'Non Disponibile', 2, 9),
	('Pavilion', 'HP', 'SP89', 'PC', 4, 700, '2021-01-23', 0, 'Non Disponibile', 2, 10),
    ('Pavilion', 'HP', 'SP89', 'PC', 4, 700, '2021-01-23', 0, 'Disponibile', 2, 11),
	('MacBook', 'Apple', 'A676', 'PC', 4, 1500, '2021-02-11', 0, 'Non Disponibile', 4, 12),
    ('MacBook', 'Apple', 'A676', 'PC', 4, 1500, '2021-02-11', 0, 'Disponibile', 4, 13);
    
-- Lotti Lavatrici
INSERT INTO Prodotto (Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia)
VALUES('Bosch Serie 2', 'Bosch', 'G8', 'Lavatrice', 6, 700, '2021-01-23', 0, 'Disponibile', 5, 14),
	('Bosch Serie 2', 'Bosch', 'G8', 'Lavatrice', 6, 700, '2021-01-23', 0, 'Disponibile', 5, 15),
    ('Bosch Serie 2', 'Bosch', 'G8', 'Lavatrice', 6, 700, '2021-01-23', 0, 'Disponibile', 5, 16),
    ('Bosch Serie 2', 'Bosch', 'G8', 'Lavatrice', 6, 700, '2021-01-23', 0, 'Disponibile', 5, 17);
    
-- Inserimento di prodotti nel carrello e effettuazione nuovo ordine    
INSERT INTO Carrello
VALUES ('Lore', 'Smartphone', 'Apple', 'A6', 2),
('Lore', 'Smartphone', 'Samsung', 'GT56', 1),
('Lore', 'Lavatrice', 'Bosch', 'G8', 1);

CALL NuovoOrdine('Lore', 'Via Ciao');

INSERT INTO Carrello
VALUES('Andre', 'Lavatrice', 'Bosch', 'G8', 1);

CALL NuovoOrdine('Andre', 'Via Salve');




/*-----------------------------------------------------------------FUNZIONALITA' LATO SERVER---------------------------------------------------------*/
-- faccio un cursore che scorre la tab Tecnico e controlla se un intervento ha la stessa provincia di tecnico, se si allora metto la Matricola del tecnico dentro l'attributo Tecnico di Intervento
DROP PROCEDURE IF EXISTS AssegnamentoTecnici;
DELIMITER $$
CREATE PROCEDURE AssegnamentoTecnici ()
BEGIN
DECLARE finito INT DEFAULT 0;
DECLARE _Tecnico int;
DECLARE _Provincia char(100);

DECLARE Cursore CURSOR FOR
SELECT T.Matricola, T.Provincia
FROM Tecnico T
WHERE (SELECT COUNT(*)
FROM Disponibilita D
WHERE D.Tecnico = T.Matricola) > 0;

DECLARE CONTINUE HANDLER
FOR NOT FOUND SET finito = 1;
-- creo la tabella che mi serve va riempita con i valori della select in cima
DROP TABLE IF EXISTS ProvinciaCliente;
CREATE TEMPORARY TABLE ProvinciaCliente (
Intervento int NOT NULL PRIMARY KEY,
Provincia char(100) NOT NULL
);
INSERT INTO ProvinciaCliente
SELECT I.CodIntervento, D.Provincia
FROM Intervento I INNER JOIN guasto G ON I.Guasto = G.CodGuasto
INNER JOIN Acquisto A ON G.Prodotto = A. Prodotto
INNER JOIN Ordine O ON A.Ordine = O.CodOrdine
INNER JOIN `Account` ACC ON O.Cliente = ACC.NomeUtente
INNER JOIN Domicilio D ON ACC.Utente = D.Utente;


-- apro il cursore e scorro i tecnici
OPEN Cursore;
preleva: LOOP
FETCH Cursore INTO _Tecnico, _Provincia;
IF finito = 1 THEN
LEAVE preleva;
END IF;
-- metto il tecnico a intervento se trovo corrispondenza nelle province
UPDATE Intervento I
SET Tecnico = _Tecnico
WHERE I.CodIntervento IN (SELECT Intervento
FROM ProvinciaCliente
WHERE Provincia = _Provincia)
AND I.Tecnico IS NULL
LIMIT 2;

-- chiudo il loop

 END LOOP preleva;
CLOSE Cursore;
END $$
DELIMITER ;




-- Inserimenti per assegnamento tecnici
INSERT INTO Guasto (Nome, Descrizione, Prodotto, Domanda)
VALUES('Alimentazione mancante', 'Non parte', 1, NULL),
	('Perdita interna', 'Perdita di acqua interna al prodotto', 15, NULL);

INSERT INTO Tecnico (Nome, Cognome, TariffaOraria, Regione, Provincia)
VALUES('Mario', 'Rossi', 10, 'Toscana', 'PI'),
	('Luigi', 'Bianchi', 8, 'Toscana', 'LI'),
    ('Giuseppe', 'Verdi', 9, 'Toscana', 'FI');

INSERT INTO Intervento (Orario, OreLavoro, Guasto, Tecnico)
VALUES('2021-05-10 10:00:00', 4, 1, NULL),
	('2021-05-11 10:00:00', 3, 2, NULL);

INSERT INTO Orario (Data, OraInizio, OraFine)
VALUES('2021-05-10', '8:00:00', '12:00:00'),
	('2021-05-10', '15:00:00', '19:00:00'),
    ('2021-05-11', '8:00:00', '12:00:00'),
	('2021-05-11', '15:00:00', '19:00:00'),
    ('2021-05-12', '8:00:00', '12:00:00'),
	('2021-05-12', '15:00:00', '19:00:00');
    
INSERT INTO Disponibilita
VALUES(1, 1),
	(1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (2, 1),
	(2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (3, 1),
	(3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (3, 6);
    
CALL AssegnamentoTecnici();




-- Controllo dei costi tra prodotti ricondizionati, prodotti nuovi e prodotti ricondizionati con modifica
DROP PROCEDURE IF EXISTS ControlloCostiRicondizionati;
DELIMITER $$
CREATE PROCEDURE ControlloCostiRicondizionati ( IN _Reso INT, OUT _controllo CHAR(255))
BEGIN
	DECLARE _MRI int DEFAULT 0; 					-- Modifica Reso Input
    DECLARE _CRI double DEFAULT 0;			-- Costo Reso Input
    DECLARE _PAC double DEFAULT 0;			-- Percentuale Aumento Costo
	DECLARE _Costo double DEFAULT 0;
    DECLARE _Sconto double DEFAULT 0;
    DECLARE _CostoRic double DEFAULT 0;
    DECLARE _Stato char(100);
    DECLARE _Modifica int DEFAULT 0;
	DECLARE finito int;
    DECLARE _valido bool DEFAULT true;
    DECLARE _Prodotto int;
    
     DECLARE Cursore CURSOR FOR
     SELECT P.Costo, P.Sconto, D.CostoRicondizionato, D.Modifica, P.Stato
     FROM Prodotto P LEFT OUTER JOIN (SELECT *
									  FROM Reso R
									  WHERE Ricondizionato = 'Si') AS D ON P.CodSeriale = D.Prodotto
     WHERE P.Lotto = (SELECT P1.Lotto 
					  FROM Prodotto P1
					  WHERE P1.CodSeriale = _Reso)
						AND P.Stato <> 'Venduto';
     
     DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
	
	-- resetto la variabile di controllo
    SET _controllo = NULL;
    
   -- metto dentro _MRI il codice della modifica del reso in input
	SELECT Modifica INTO _MRI
    FROM Reso
    WHERE Prodotto = _Reso;
    
    -- se il ricondizionato in questione ha delle modifiche esterne, aggiorno il suo costo
	IF _MRI IS NOT NULL THEN
		SELECT PercentualeAumentoCosto INTO _PAC
        FROM Reso R INNER JOIN Modifica M ON R.Modifica = M.CodModifica 
        WHERE R.Prodotto = _Reso;

		UPDATE Reso
        SET CostoRicondizionato = CostoRicondizionato + (CostoRicondizionato * _PAC/100)					
        WHERE Prodotto = _Reso;
	END IF;
    
	-- metto nella variabile _CRI il costo del ricondizionato in input
    SELECT CostoRicondizionato INTO _CRI
    FROM Reso
    WHERE Prodotto = _Reso;
    
    -- apro il cursore
      OPEN Cursore;
	  preleva: LOOP
		FETCH Cursore INTO _Costo, _Sconto, _CostoRic, _Modifica, _Stato;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
       
       -- se il reso in input è modificato mentre il prodotto preso dal cursore non è modificato, controllo che il prezzo del modificato sia maggiore, in caso contrario do errore
		IF _MRI IS NOT NULL AND (_Modifica IS NULL AND _Stato = 'Ricondizionato') THEN
			IF _CRI <= _Costo THEN
               SET _controllo = 'Costo del prodotto ricondizionato modificato è uguale o inferiore al costo del prodotto ricondizionato non modificato';
                SET _valido = FALSE;
                LEAVE preleva;
			END IF;
		END IF;
        
        -- se il reso è modificato il suo prezzo deve essere inferiore al prezzo del prodotto nuovo, anche se questo è soggetto a sconti
        IF _MRI IS NOT NULL AND (_Stato = 'Disponibile' OR _Stato = 'Non Disponibile')THEN
			IF _CRI >= (_Costo - _Costo * (_Sconto/100)) THEN
				  SET _controllo = 'Costo del prodotto ricondizionato modificato è uguale o maggiore del costo del prodotto nuovo';
				SET _valido = FALSE;
                LEAVE preleva;
			END IF;
		END IF;
	 END LOOP preleva;
     CLOSE Cursore;
     
	-- se il costo del ricondizionato soddisfa i vincoli, allora inseriamo il ricondizionato nella tab Prodotto, in modo da ricodificarlo
	IF _valido IS TRUE THEN
		INSERT INTO Prodotto  (Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia)
       SELECT Nome, Marca, Modello, Tipo, Facce, Costo, DataProduzione, Sconto, Stato, Lotto, Garanzia
       FROM Prodotto
       WHERE CodSeriale = _Reso;
       
       DELETE FROM Prodotto
       WHERE CodSeriale = _Reso;
       
	-- modifico il costo mettendo quello del ricondizionato
	SET _Prodotto = LAST_INSERT_ID();

	UPDATE Prodotto
	SET Costo = _CRI, Stato = 'Ricondizionato'
	WHERE CodSeriale = _Prodotto;
    
	-- inserisco una nuova garanzia e metto il suo codice al prodtto ricondizionato che abbiamo inserito nella tab Prodotto
	INSERT INTO Garanzia (InizioGaranzia, DurataGaranzia)
	VALUES (NULL, 6);
	UPDATE Prodotto
	SET Garanzia = (SELECT CodGaranzia
					FROM Garanzia
			        WHERE CodGaranzia = LAST_INSERT_ID())
	WHERE CodSeriale = _Prodotto;
        
	SET _controllo = 'Il reso è stato inserito dentro la tabella dei prodotti';
        
    END IF;
END $$
DELIMITER ;




-- Inserimento per ControlloCostiRicondizionati
-- Inseriementi giusti di 2 resi
INSERT INTO Motivazione (Nome, Descrizione)
VALUES('Diritto di Recesso', 'A'),
('Diritto di Recesso', 'B'),
('Diritto di Recesso', 'C'),
('Diritto di Recesso', 'D');

INSERT INTO Modifica
VALUES (1, 'A', 5);

INSERT INTO Reso
VALUES(1, 'no', NULL, NULL, 1, 1),
(6, 'no', NULL, NULL, 2, NULL);

INSERT INTO Test
VALUES (1, 'Controllo Accensione', 1, 'Si', 0, 70);

INSERT INTO Verifica
VALUES (1, 1, NULL),
(6,1, NULL);

UPDATE Verifica
SET Esito = 'Positivo'
WHERE Reso = 6;

SELECT @controllo;

UPDATE Verifica
SET Esito = 'Positivo'
WHERE Reso = 1;

SELECT @controllo;


-- Inserimento non fatto perchè il prodotto ricondizionato con modifica ha un prezzo MAGGIORE del prodotto nuovo
INSERT INTO Modifica
VALUES (2, 'B', 100);

INSERT INTO Reso
VALUES(14, 'no', NULL, NULL, 4, 2);

INSERT INTO Verifica
VALUES (14, 1, NULL);

UPDATE Verifica
SET Esito = 'Positivo'
WHERE Reso = 14;

SELECT @controllo;


-- Inserimento non fatto perchè il prodotto ricondizionato con modifica ha un prezzo MINORE di un prodotto ricondizionato senza modifica
INSERT INTO Motivazione (Nome, Descrizione)
VALUES ('Diritto di Recesso', 'D');

INSERT INTO Modifica
VALUES (3, 'B', -10);

INSERT INTO Reso
VALUES(7, 'no', NULL, NULL, 5, 3);

INSERT INTO Verifica
VALUES (7, 1, NULL);

UPDATE Verifica
SET Esito = 'Positivo'
WHERE Reso = 7;

SELECT @controllo;  
     


     
-- analisi settimanale delle vendite e degli ordini pendenti
DROP PROCEDURE IF EXISTS Analisi;
DELIMITER $$
CREATE PROCEDURE Analisi()
BEGIN

    -- Inserisco la quantità di prodotti appartenenti agli ordini dell'ultima settimana
	-- suddividendoli per tipo, marca e modello
    INSERT INTO ReportVendite
    SELECT Tipo, Marca, Modello, COUNT(*)
    FROM Prodotto P INNER JOIN Acquisto A ON P.CodSeriale = A.Prodotto
		INNER JOIN Ordine O ON A.Ordine = O.CodOrdine
    WHERE DATE(O.IstanteOrdine) >= CURRENT_DATE - INTERVAL 7 DAY
		AND P.Stato = 'Venduto'
    GROUP BY Tipo, Marca, Modello;
    
    -- Inserisco la quantità di prodotti appartenenti agli ordini pendenti dell'ultima settimana
	-- suddividendoli per tipo, marca e modello
    INSERT INTO ReportProdottiPendenti
    SELECT Tipo, Marca, Modello, SUM(OP.Quantita)
    FROM ProdottoPendente OP INNER JOIN Ordine O ON OP.CodOrdine = O.CodOrdine
    WHERE DATE(O.IstanteOrdine) >= CURRENT_DATE - INTERVAL 7 DAY
    GROUP BY Tipo, Marca, Modello;
END $$
DELIMITER ;



-- Inserimento per Analisi   
INSERT INTO Carrello
VALUES ('Lore', 'Smartphone', 'Apple', 'A6', 1),
('Lore', 'PC', 'HP', 'SP89', 2);

CALL NuovoOrdine('Lore', 'Via Ciao');
CALL Analisi();




/*----------------------------------------------------------OPERAZIONI (DALLA 2 IN POI)---------------------------------------------------------------*/

-- 2) Tracciare la spedizione
DROP PROCEDURE IF EXISTS TracciaSpedizione;
DELIMITER $$
CREATE PROCEDURE TracciaSpedizione(IN _CodOrdine INT, OUT StatoSpedizione_ CHAR(100))
BEGIN
	-- Seleziono NomeHub, Indirizzo e StatoSpedizione del CodOrdine dato in ingresso ordinando la tabella per tappe crescenti
    SELECT H.NomeHub, H.Indirizzo
    FROM Spedizione S INNER JOIN Percorso P ON P.Spedizione = S.CodSpedizione
		INNER JOIN Hub H ON H.NomeHub = P.Hub
    WHERE Ordine = _CodOrdine
    ORDER BY P.Tappa;
    
    SELECT StatoSpedizione INTO StatoSpedizione_
    FROM Spedizione
    WHERE Ordine = _CodOrdine;
END $$
DELIMITER ;



-- Inserimento per TracciaSpedizione
INSERT INTO Spedizione (DataConsegnaPrevista, DataConsegnaEffettiva, StatoSpedizione, Ordine)
VALUES('2021-01-20', NULL, 'Spedito', 1);

INSERT INTO Hub
VALUES('HubPisa', 'Via Francia'),
	('HubLivorno', 'Via Germania');
    
INSERT INTO Percorso
VALUES (1, 'HubPisa', 1),
	(1, 'HubLivorno', 2);
    
CALL TracciaSpedizione(1, @stato);
SELECT @stato;





-- 3) Calcolo ed inserimento di una ricevuta
DROP PROCEDURE IF EXISTS CalcoloRicevuta;
DELIMITER $$
CREATE PROCEDURE CalcoloRicevuta(IN _CodIntervento INT, _ModPagamento CHAR(100))
BEGIN
	DECLARE _OreLavoro DOUBLE;
    DECLARE _TariffaOraria DOUBLE;
    DECLARE _Quantita INT DEFAULT 0;
    DECLARE _CostoPezzo DOUBLE;
    DECLARE _CostoTotPezzi DOUBLE DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    
    -- Cursore che scorre Quantità e Costo dei Pezzi di Ricambio
    DECLARE Cursore CURSOR FOR
		SELECT R.Quantita, P.Costo
        FROM OrdinePezziRicambio O INNER JOIN Richiesta R ON O.CodOrdine = R.Ordine
			INNER JOIN PezzoRicambio P ON P.CodPezzo = R.Pezzo 
        WHERE O.Intervento = _CodIntervento;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
	
    -- Scorro i Pezzi di Ricambio ordinati aggiornando ogni volta il costo totale
	OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _Quantita, _CostoPezzo;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        SET _CostoTotPezzi = _CostoTotPezzi + _Quantita*_CostoPezzo;
    END LOOP preleva;
    CLOSE Cursore;
    
    -- Calcolo la parcella del tecnico
    SELECT I.OreLavoro, T.TariffaOraria INTO _OreLavoro, _TariffaOraria
    FROM Intervento I INNER JOIN Tecnico T ON I.Tecnico = T.Matricola
    WHERE I.CodIntervento = _CodIntervento;
    
    -- Inserisco i dati nella ricevuta
    INSERT INTO Ricevuta (ModPagamento, Costo, Intervento)
    VALUES(_ModPagamento, _CostoTotPezzi + _OreLavoro*_TariffaOraria, _CodIntervento);
END $$
DELIMITER ;



-- Inserimento per CalcoloRicevuta
INSERT INTO OrdinePezziRicambio (DataOrdine, DataPrevistaConsegna, DataEffettivaConsegna, Intervento)
VALUES('2021-01-11', '2021-01-18', '2021-01-20', 1);

INSERT INTO PezzoRicambio (Nome, Costo)
VALUES('Display', 50),
	('Batteria', 30);

INSERT INTO Richiesta
VALUES(1, 1, 1),
	(1, 2, 2);
    
CALL CalcoloRicevuta(1, 'Contanti');
CALL CalcoloRicevuta(2, 'Contanti');




-- 4) Calcolo di unità perse e tempo di recupero di ogni lotto
DROP PROCEDURE IF EXISTS RecuperoLotto;
DELIMITER $$
CREATE PROCEDURE RecuperoLotto()
BEGIN
	DECLARE _ProdottoTarget int;
    DECLARE _StazioneTarget int;
	DECLARE _RankingOperazione int;
    DECLARE _OrdinamentoStazione int;
    DECLARE _LineaTarget int;
    DECLARE finito int;
    DECLARE _TempoTotale int DEFAULT 0;
    DECLARE _TempoOperazioni int DEFAULT 0;
    DECLARE _TempoStazione int DEFAULT 0;
    DECLARE _Ore int;
    DECLARE _Minuti int;
    
    -- Cursore che scorre Prodotto, NOperazioneInterrotta, Ordinamento della stazione e numero di Linea
	DECLARE Cursore CURSOR FOR
    SELECT U.Prodotto, A.Ranking, S.Ordinamento, S.Linea, S.NStazione
    FROM UnitaPerse U INNER JOIN Stazione S ON U.Stazione = S.NStazione
		INNER JOIN Assegnamento A ON U.Stazione = A.Stazione
    WHERE DATE(U.Istante) = CURRENT_DATE
		AND A.Operazione = U.OperazioneInterrotta;
    
    DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    -- Scorro i Prodotti Persi calcolando il TempoTotale di recupero
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _ProdottoTarget, _RankingOperazione, _OrdinamentoStazione, _LineaTarget, _StazioneTarget;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Calcolo del tempo delle stazioni rimanenti
        SELECT SUM(S.TempoMedio) INTO _TempoStazione
        FROM Stazione S
        WHERE S.Linea = _LineaTarget
			AND S.Ordinamento > _OrdinamentoStazione;
            
		IF _TempoStazione IS NULL THEN
			SET _TempoStazione = 0;
		END IF;
        
        -- Calcolo del tempo rimanente alla stazione di interruzione
		SELECT SUM(O.TempoMedio) INTO _TempoOperazioni
        FROM Assegnamento A INNER JOIN Operazione O ON A.Operazione = O.CodOperazione
        WHERE A.Stazione = _StazioneTarget
			AND A.Ranking >= _RankingOperazione;
		
        -- TempoTotale di ogni prodotto
		SET _TempoTotale = _TempoStazione + _TempoOperazioni;
        
        -- Inserisco i prodotti persi col relativo tempo di recupero in una tabella        
        INSERT INTO ProdottiPersi
        VALUES(_ProdottoTarget, _TempoTotale);
    END LOOP preleva;
    CLOSE Cursore;
	
    -- Per ogni lotto stampo il codice del lotto, il suo numero di unità perse, le ore e i minuti necessari al recupero
    SELECT P.Lotto, COUNT(*) AS UnitaPerse, TRUNCATE((SUM(PP.Tempo) / 60), 0) AS Ore, SUM(PP.Tempo) % 60 AS Minuti
    FROM ProdottiPersi PP INNER JOIN Prodotto P ON PP.Prodotto = P.CodSeriale
    GROUP BY P.Lotto;
END $$
DELIMITER ;



-- Inserimento per RecuperoLotto
INSERT INTO UnitaPerse
VALUES(9, 3, CURRENT_TIMESTAMP, 5),
	(10, 3, CURRENT_TIMESTAMP, 7),
    (12, 4, CURRENT_TIMESTAMP, 6);
    
CALL RecuperoLotto();




-- 5) Ricerca delle operazioni di una linea di assemblaggio
DROP PROCEDURE IF EXISTS OperazioniLinea;
DELIMITER $$
CREATE PROCEDURE OperazioniLinea(IN _CodLinea INT)
BEGIN
    -- Seleziono tutti i campi di Operazione delle operazioni che fanno parte della linea di assemblaggio inserita
	SELECT O.*
    FROM Successione S INNER JOIN Operazione O ON S.Operazione = O.CodOperazione
    WHERE S.Linea = _CodLinea
    ORDER BY S.Ordine;
END $$
DELIMITER ;


-- Chiamata procedure
CALL OperazioniLinea(1);


-- 6) Disponibilità dei tecnici
DROP PROCEDURE IF EXISTS DisponibilitaTecnici;
DELIMITER $$
CREATE PROCEDURE DisponibilitaTecnici(IN _Provincia char(100))
BEGIN
	-- Seleziono le fasce orarie distinte dei tecnici con la stessa provincia inserita
	SELECT DISTINCT O.Data, O.OraInizio, O.OraFine
    FROM Tecnico T INNER JOIN Disponibilita D ON T.Matricola = D.Tecnico
		INNER JOIN Orario O ON D.CodOrario = O.CodOrario
    WHERE T.Provincia = _Provincia;
END $$
DELIMITER ;


-- Chiamata procedure
CALL DisponibilitaTecnici('LI');


-- 7) Verifica della disponibilità di un prodotto
DROP PROCEDURE IF EXISTS DisponibilitaProdotto;
DELIMITER $$
CREATE PROCEDURE DisponibilitaProdotto(IN _Tipo CHAR(100), _Marca CHAR(100), _Modello CHAR(100))
BEGIN
	-- Seleziono i prodotti target aggiungendo accanto alle caratterstiche inserite il numero di prodotti disponibili
	SELECT P.Tipo, P.Marca, P.Modello, COUNT(*) AS Disponibili
    FROM Prodotto P
    WHERE P.Tipo = _Tipo AND P.Marca = _Marca AND P.Modello = _Modello
		AND (P.Stato = 'Disponibile' OR P.Stato = 'Ricondizionato');
END $$
DELIMITER ;


-- Chiamata procedure
CALL DisponibilitaProdotto('Smartphone', 'Samsung', 'GT56');


-- 8 Sconto lampo per i prodotti più vecchi
DROP PROCEDURE IF EXISTS ScontoLampo;
DELIMITER $$
CREATE PROCEDURE ScontoLampo()
BEGIN
	-- Aggiorno il campo sconto dei prodotti disponibili più vecchi
	UPDATE Prodotto P
    SET P.Sconto = 20
    WHERE P.Stato = 'Disponibile' OR P.Stato = 'Ricondizionato'
    ORDER BY P.DataProduzione
    LIMIT 2;
END $$
DELIMITER ;



-- Chiamata procedure
CALL ScontoLampo();





/*---------------------------------------------------------------------DATA ANALYTICS--------------------------------------------------------------------------------*/
-- Controllo quali stazioni hanno una bassa efficienza (>= 0.5)
DROP PROCEDURE IF EXISTS StazioniCritiche;
DELIMITER $$
CREATE PROCEDURE StazioniCritiche(IN _CodLinea INT, OUT _StazioniCritiche CHAR(255))
BEGIN
	DECLARE _Stazione INT;
    DECLARE _TempoMedio INT;
    DECLARE _TempoLimite INT;
    DECLARE _EfficienzaOperatori DOUBLE;
    DECLARE finito INT DEFAULT 0;
    
    -- Cursore che scorre le stazioni di una linea prendendo quelle poco efficienti
    DECLARE Cursore CURSOR FOR
		SELECT Stazione, InefficienzaOperatori
        FROM EfficienzaStazioni
        WHERE Linea = _CodLinea;
        
	DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    -- Inizialmente non ci sono stazioni critiche
    SET _StazioniCritiche = '';
    
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _Stazione, _EfficienzaOperatori;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Se l'inefficienza degli operatori assegnati ad una stazione supera lo 0,5 la stazione è critica
        IF _EfficienzaOperatori >= 0.5 THEN
			IF _StazioniCritiche = '' THEN
				SET _StazioniCritiche = _Stazione;
			ELSE
				-- Inserimento in stazioni critiche
				SET _StazioniCritiche = CONCAT(_StazioniCritiche, ' - ', _Stazione);
            END IF;
		END IF;
    END LOOP preleva;
    CLOSE Cursore;
END $$
DELIMITER ;




-- Percentuale resi per difetti di una linea tra i prodotti venduti
DROP PROCEDURE IF EXISTS ResiLinea;
DELIMITER $$
CREATE PROCEDURE ResiLinea(IN _CodLinea INT, OUT _PercentualeResi DOUBLE)
BEGIN
	DECLARE _NResi INT DEFAULT 0;
    DECLARE _NProdotti INT DEFAULT 0;
    
    -- Calcolo il numero di resi difettosi di una linea
	SELECT COUNT(*) INTO _NResi
	FROM Reso R INNER JOIN Prodotto P ON R.Prodotto = P.CodSeriale
		INNER JOIN Lotto L ON P.Lotto = L.CodLotto
		INNER JOIN Motivazione M ON R.Motivazione = M.CodMotivazione
	WHERE L.Linea = _CodLinea
		AND M.Nome = 'Difettoso';
        
	IF _NResi IS NULL THEN
		SET _NResi = 0;
	END IF;
	
    -- Calcolo i prodotti venduti di una linea
	SELECT COUNT(*) INTO _NProdotti
	FROM Prodotto P INNER JOIN Lotto L ON P.Lotto = L.CodLotto
	WHERE L.Linea = _CodLinea
		AND P.Stato = 'Venduto';
	
    -- Calcolo la percentuale di resi
    IF _NProdotti = 0 THEN
		SET _PercentualeResi = 0;
	ELSE
		SET _PercentualeResi = (_NResi/_NProdotti)*100;
	END IF;
END $$
DELIMITER ;




-- Controllo l'efficienza dell'operatore di una stazione attraverso un valore compreso tra 0 (efficiente) e 1 (inefficiente)
DROP PROCEDURE IF EXISTS EfficienzaOperatoriStazione;
DELIMITER $$
CREATE PROCEDURE EfficienzaOperatoriStazione(IN _Stazione INT, OUT _OperatoriScarsi CHAR(255))
BEGIN
	DECLARE _EfficienzaMediaOperatori DOUBLE;
	DECLARE _CodLinea INT;
	DECLARE _Operatore INT;
    DECLARE _Operazione INT;
    DECLARE _Somma DOUBLE DEFAULT 0;
    DECLARE _Ranking DOUBLE;
    DECLARE _NOperatori INT;
    DECLARE _NOperazioni INT DEFAULT 0;
    DECLARE _TempoLimite INT;
    DECLARE _TempoMedio INT;
    DECLARE _TempoOperatore INT;
    DECLARE finito INT DEFAULT 0;
    
    -- Cursore che scorre le operazioni della stazione
    DECLARE Cursore CURSOR FOR
		SELECT Operazione
        FROM Assegnamento
        WHERE Stazione = _Stazione;
	
    -- Cursore che scorre gli operatori della stazione calcolando il tempo medio che impiegano per svolgere tutte le operazioni
    DECLARE Cursore2 CURSOR FOR
		SELECT O.Matricola, SUM(SO.TempoMedio)
		FROM Operatore O NATURAL JOIN Assegnamento A
			INNER JOIN StatisticheOperatore SO ON O.Matricola = SO.Operatore AND A.Operazione = SO.Operazione
		WHERE O.Matricola IN (SELECT *
							  FROM OperatoriStazione)
			AND O.Stazione = _Stazione
		GROUP BY O.Matricola;
	
	DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    -- Seleziono gli operatori della stazione target e li salvo in una tabella
    DROP TABLE IF EXISTS OperatoriStazione;
    CREATE TEMPORARY TABLE OperatoriStazione (
		Matricola INT PRIMARY KEY
	);
    
    INSERT INTO OperatoriStazione
    SELECT Matricola
    FROM Operatore
    WHERE Stazione = _Stazione;
    
     -- Conto gli operatori (si suppone che si abbiano le statistiche di ogni operatore su ogni stazione)
    SELECT COUNT(*) INTO _NOperatori
    FROM Operatore;
    
    -- Salvo il codice linea e il tempo limite a cui appartiene la stazione target
    SELECT S.Linea, L.TempoLimite INTO _CodLinea, _TempoLimite
    FROM Stazione S INNER JOIN LineaAssemblaggio L ON S.Linea = L.CodLinea
    WHERE S.NStazione = _Stazione;
    
    -- Salvo il tempo medio della stazione
    SELECT TempoMedio INTO _TempoMedio
    FROM Stazione
    WHERE NStazione = _Stazione;
    
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _Operazione;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
	
    -- Creo la classifica degli operatori per l'operazione target e ci inserisco i valori
    DROP TABLE IF EXISTS Classifica;
    CREATE TEMPORARY TABLE IF NOT EXISTS Classifica (
		Operatore INT PRIMARY KEY,
        Ranking INT
	);
    
    INSERT INTO Classifica
	SELECT Operatore, RANK() OVER(ORDER BY TempoMedio) - 1
    FROM StatisticheOperatore
    WHERE Operazione = _Operazione;
    
    -- Seleziono la media dei ranking degli operatori della stazione target
    SELECT AVG(Ranking) INTO _Ranking
    FROM Classifica
    WHERE Operatore IN (SELECT Matricola
					    FROM OperatoriStazione);
    
    -- Sommo tutti i ranking
    SET _Somma = _Somma + _Ranking;
    
    -- Conto le operazioni della stazione
    SET _NOperazioni = _NOperazioni + 1;
    
    END LOOP preleva;
    CLOSE Cursore;
    
    -- Calcolo l'efficienza media degli operatori e la inserisco nella tabella efficienza stazioni
    SET _EfficienzaMediaOperatori = (_Somma/_NOperazioni) / _NOperatori;
    
    SET finito = 0;
    SET _OperatoriScarsi = '';
    
	OPEN Cursore2;
    preleva: LOOP
		FETCH Cursore2 INTO _Operatore, _TempoOperatore;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Se il tempo medio che impiega un operatore a svolgere le operazioni in una stazione è maggiore del tempo limite lo segnalo
        IF _TempoOperatore >= _TempoLimite THEN
			IF _OperatoriScarsi = '' THEN
				SET _OperatoriScarsi = _Operatore;
			ELSE
				SET _OperatoriScarsi = CONCAT(_OperatoriScarsi, ' - ', _Operatore);
			END IF;
		END IF;
    END LOOP preleva;
    CLOSE Cursore2;
    
    -- Si usa replace perchè se la stazione target era già stata inserita vengono cancellate le vecchie tuple e inserite le nuove
    REPLACE INTO EfficienzaStazioni
    VALUES(_CodLinea, _Stazione, _EfficienzaMediaOperatori, _OperatoriScarsi, _TempoLimite - _TempoMedio);
END $$
DELIMITER ;




-- Controllo l'efficienza degli operatori di una linea attraverso un valore compreso tra 0 (efficiente) e 1 (inefficiente)
DROP PROCEDURE IF EXISTS EfficienzaOperatoriLinea;
DELIMITER $$
CREATE PROCEDURE EfficienzaOperatoriLinea(IN _CodLinea INT, OUT _EfficienzaLinea DOUBLE, OUT _TempoPerso INT, OUT _OperatoriScarsiLinea CHAR(255))
BEGIN
	DECLARE finito INT DEFAULT 0;
    DECLARE _NStazione INT;
    DECLARE _OperatoriScarsi CHAR(255) DEFAULT '';
    
    -- Cursore che scorre le stazioni della linea target
    DECLARE Cursore CURSOR FOR
		SELECT NStazione
        FROM Stazione
        WHERE Linea = _CodLinea;
        
	DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _NStazione;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Chiamata alla procedura che inserisce i dati delle stazioni della linea target nella tabella EfficienzaStazioni
        CALL EfficienzaOperatoriStazione(_NStazione, _OperatoriScarsi);
		IF _OperatoriScarsi <> '' THEN
			IF _OperatoriScarsiLinea IS NULL THEN
				SET _OperatoriScarsiLinea = _OperatoriScarsi;
			ELSE
				SET _OperatoriScarsiLinea = CONCAT(_OperatoriScarsiLinea, ' - ', _OperatoriScarsi);
			END IF;
		END IF;
    END LOOP preleva;
    CLOSE Cursore;
    
    -- Si selezionano la media dell'efficienza e la somma dei tempi persi alle stazioni
    SELECT AVG(InefficienzaOperatori), SUM(TempoPerso) INTO _EfficienzaLinea, _TempoPerso
    FROM EfficienzaStazioni
    WHERE Linea = _CodLinea;
END $$
DELIMITER ;




-- Controllo l'efficienza dell'intera produzione attraverso un valore compreso tra 0 (efficiente) e 1 (inefficiente)
DROP PROCEDURE IF EXISTS EfficienzaProduzione;
DELIMITER $$
CREATE PROCEDURE EfficienzaProduzione()
BEGIN
	DECLARE _CodLinea INT;
    DECLARE _NStazioni INT DEFAULT 0;
    DECLARE _Sequenza INT;
	DECLARE _StazioniCritiche CHAR(255) DEFAULT '';
    DECLARE _PercentualeResi DOUBLE DEFAULT 0;
    DECLARE _Efficienza DOUBLE;
    DECLARE _TempoPerso INT;
    DECLARE _OperatoriScarsi CHAR(255);
    DECLARE finito INT DEFAULT 0;
    
    -- Cursore che scorre tutte le linee di assemblaggio
    DECLARE Cursore CURSOR FOR
		SELECT CodLinea, Sequenza
        FROM LineaAssemblaggio;
        
	DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _CodLinea, _Sequenza;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        IF _Sequenza IS NULL THEN
			ITERATE preleva;
		END IF;
        
        -- Si chiamano le precedenti procedure che danno in output i dati di ogni linea
        CALL ResiLinea(_CodLinea, _PercentualeResi);
        CALL EfficienzaOperatoriLinea(_CodLinea, _Efficienza, _TempoPerso, _OperatoriScarsi);
        CALL StazioniCritiche(_CodLinea, _StazioniCritiche);
        
        SELECT COUNT(*) INTO _NStazioni
        FROM Stazione
        WHERE Linea = _CodLinea;
        
        -- Si inseriscono i dati ottenuti nella tabella EfficienzaProduzione
        INSERT INTO EfficienzaProduzione
        VALUES(_CodLinea, _NStazioni, _StazioniCritiche, _OperatoriScarsi, _PercentualeResi, _Efficienza, _TempoPerso, ROUND(_TempoPerso/_NStazioni));
    END LOOP preleva;
    CLOSE Cursore;
END $$
DELIMITER ;

-- Chiamata procedure
CALL EfficienzaProduzione();


/*---------------------------------CBR---------------------------------*/
DROP PROCEDURE IF EXISTS RetrieveReuse;
DELIMITER $$
CREATE PROCEDURE RetrieveReuse ()
BEGIN
	DECLARE finito INT DEFAULT 0;
    DECLARE _Guasto INT;
    DECLARE _GuastoPrecedente INT DEFAULT NULL;
    DECLARE _NSintomiAttuali INT;
    DECLARE _NSintomiPrecedenti INT;
    DECLARE _NSintomiComuni INT;
    DECLARE _Rimedio INT;
    DECLARE _PoolSoluzioni CHAR(255) DEFAULT '';
    
    -- Cursore che scorre i sintomi dei guasti
    DECLARE Cursore CURSOR FOR
		SELECT DISTINCT Guasto
        FROM Sintomi;
        
    -- Cursore che scorre le soluzioni dei 3 guasti con lo score più alto    
	DECLARE Cursore2 CURSOR FOR
		SELECT Guasto, Rimedio
        FROM Soluzioni
        WHERE Guasto IN (SELECT Guasto
					     FROM GuastiTarget)
		ORDER BY Guasto;
        
	DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET finito = 1;
    
    -- Creazione tabella contenente i vari score
    DROP TABLE IF EXISTS PunteggioSintomi;
    CREATE TEMPORARY TABLE IF NOT EXISTS PunteggioSintomi (
		GuastoPrecedente INT NOT NULL PRIMARY KEY,
		Score DOUBLE NOT NULL,
		Rimedi CHAR(255) DEFAULT NULL
	);
    
	-- Conto i sintomi attuali
	SELECT COUNT(*) INTO _NSintomiAttuali
	FROM NuoviSintomi;
            
    OPEN Cursore;
    preleva: LOOP
		FETCH Cursore INTO _Guasto;
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        -- Conto i sintomi precedenti
        SELECT COUNT(*) INTO _NSintomiPrecedenti
        FROM Sintomi
        WHERE Guasto = _Guasto;
        
        -- Conto i sintomi in comune
        SELECT COUNT(*) INTO _NSintomiComuni
        FROM NuoviSintomi NS INNER JOIN Sintomi S ON NS.Sintomo = S.Sintomo
        WHERE S.Guasto = _Guasto;
        
        -- Inserisco i vari score nella tabella
        INSERT INTO PunteggioSintomi (GuastoPrecedente, Score)
        VALUES(_Guasto, _NSintomiComuni*_NSintomiComuni / (_NSintomiPrecedenti*_NSintomiAttuali));
    END LOOP preleva;
    CLOSE Cursore;
    
    -- Salvo i 3 guasti con lo score più alto in una tabella
    DROP TABLE IF EXISTS GuastiTarget;
	CREATE TEMPORARY TABLE IF NOT EXISTS GuastiTarget (
		Guasto INT NOT NULL PRIMARY KEY
	);
    
    INSERT INTO GuastiTarget
    SELECT GuastoPrecedente
    FROM PunteggioSintomi
	ORDER BY Score DESC
	LIMIT 3;
    
    -- Lascio nella tabella solo i 3 guasti con lo score più alto
    DELETE FROM PunteggioSintomi
    WHERE GuastoPrecedente NOT IN (SELECT *
					     FROM GuastiTarget);
	
    SET finito = 0;
    
    OPEN Cursore2;
    preleva: LOOP
		FETCH Cursore2 INTO _Guasto, _Rimedio;
        IF finito = 1 THEN
			-- Update dell'ultimo guasto
            UPDATE PunteggioSintomi
			SET Rimedi = _PoolSoluzioni
            WHERE GuastoPrecedente = _Guasto;
			LEAVE preleva;
		END IF;
        
        IF _GuastoPrecedente IS NULL THEN
			SET _GuastoPrecedente = _Guasto;
		END IF;
        
        -- Quando passo al prossimo guasto inserisco i rimedi concatenati del guasto appena passato nella tabella punteggio sintomi
        IF _GuastoPrecedente <> _Guasto THEN
			UPDATE PunteggioSintomi
			SET Rimedi = _PoolSoluzioni
            WHERE GuastoPrecedente = _GuastoPrecedente;
			SET _PoolSoluzioni = '';
		END IF;
        
        IF _PoolSoluzioni = '' THEN
			SET _PoolSoluzioni = _Rimedio;
		ELSE
			SET _PoolSoluzioni = CONCAT(_PoolSoluzioni, ' - ', _Rimedio);
		END IF;
        
        SET _GuastoPrecedente = _Guasto;
    END LOOP preleva;
    CLOSE Cursore2;
    
    -- Stampa della tabella
    SELECT *
    FROM PunteggioSintomi
    ORDER BY Score DESC;
END $$
DELIMITER ;




DROP PROCEDURE IF EXISTS ReviseRetain;
DELIMITER $$
CREATE PROCEDURE ReviseRetain ()
BEGIN
		DECLARE _NRimediSuggeriti INT DEFAULT 0;
        DECLARE _NRimediUtilizzati INT DEFAULT 0;
        DECLARE _NRimediComuni INT DEFAULT 0;
        DECLARE _Guasto INT DEFAULT 0;
        DECLARE _Score DOUBLE DEFAULT 0;
        DECLARE _Soglia DOUBLE DEFAULT 0.6;
        DECLARE _Controllo BOOL DEFAULT TRUE;
        DECLARE _MaxId INT DEFAULT 0;
        DECLARE finito INT DEFAULT 0;
        
        -- cursore che scorre il codice dei guasti più simili a quello che stiamo trattando
        DECLARE Cursore CURSOR FOR
		SELECT GuastoPrecedente
        FROM PunteggioSintomi;
        
        -- cursore che scorre gli score x confrontarli con la soglia e nel caso inserirli
        DECLARE Cursore2 CURSOR FOR
        SELECT GuastoPrecedente, Score
        FROM PunteggioRimedi;
       
		DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
        
        -- mi salvo il numero dei rimedi che ho utilizzato x risolvere il guasto
        SELECT COUNT(*) INTO _NRimediUtilizzati
        FROM RimediUtilizzati;
        
        -- creo la tabella dove metterò i risultati finali
		DROP TABLE IF EXISTS PunteggioRimedi;
		CREATE TEMPORARY TABLE IF NOT EXISTS PunteggioRimedi (
		GuastoPrecedente INT NOT NULL PRIMARY KEY,
		Score DOUBLE NOT NULL,
		Rimedi CHAR(255) DEFAULT NULL
		);
    
		-- dentro ci copio la tabella PUNTEGGIO Sintomi (perchè devo modificare solo lo score)
        INSERT INTO PunteggioRimedi
        SELECT *
        FROM PunteggioSintomi;
        
        -- apro il cursore
        OPEN Cursore;
		preleva: LOOP
			FETCH Cursore INTO _Guasto;
			IF finito = 1 THEN
				LEAVE preleva;
			END IF;
			
			-- mi salvo il numero di rimedi suggeriti del guasto
			SELECT COUNT(*) INTO _NRimediSuggeriti
			FROM Soluzioni 
			WHERE Guasto = _Guasto;
        
			-- trovo i rimedi in comuni tra quelli suggeriti e quelli utilizzati
			SELECT COUNT(*) INTO _NRimediComuni
			FROM Soluzioni S INNER JOIN RimediUtilizzati RU ON S.Rimedio = RU.Rimedio
			WHERE S.Guasto = _Guasto;
        
			-- modifico dentro la tab PUNTEGGIOSINTOMI lo score di somiglianza fra i rimedi
			UPDATE PunteggioRimedi
			SET Score = (_NRimediComuni*_NRimediComuni/(_NRimediUtilizzati*_NRimediSuggeriti))
			WHERE GuastoPrecedente = _Guasto;
        
		END LOOP preleva;
		CLOSE Cursore;
        
        SET finito=0;
        
        -- apro il secondo cursore
		OPEN Cursore2;
		preleva: LOOP
			FETCH Cursore2 INTO _Guasto, _Score;
			IF finito = 1 THEN
				LEAVE preleva;
			END IF;

			-- se lo score del guasto è maggiore della soglia scelta, allora esco dal cursore perhè non devo inserirlo
			IF _Score > _Soglia THEN
				SET _Controllo = FALSE;
                LEAVE preleva;
			END IF;
            
        END LOOP preleva;
		CLOSE Cursore2;
        
		-- stampa la tab PunteggioRimedi
		SELECT *
		FROM PunteggioRimedi
		ORDER BY Score DESC;
        
        -- se la variabile _Controllo è rimasta su TRUE, allora tutti gli score sono < della soglia, quindi inserisco nel db
            IF _Controllo = TRUE THEN
				SELECT Max(Guasto) INTO _MaxID
                FROM Sintomi;
                
                UPDATE NuoviSintomi
                SET Guasto = _MaxId + 1;
            
				INSERT INTO Sintomi
                SELECT *
                FROM NuoviSintomi;
                
                UPDATE RimediUtilizzati
                SET Guasto = _MaxId + 1;
                
                INSERT INTO Soluzioni
                SELECT *
                FROM RimediUtilizzati;
                -- stampa a video l'inserimento del nuovo guasto
                SELECT 'Abbiamo inserito il guasto appena risolto nella nostra base di conoscenza';
			ELSE
				SELECT 'Non abbiamo inserito il guasto appena risolto perché avevamo già un caso simile nella nostra base di conoscenza';
			END IF;
            
            -- Si svuotano le tabelle che serviranno successivamente per il prossimo guasto
            TRUNCATE TABLE RimediUtilizzati;
            TRUNCATE TABLE NuoviSintomi;
END $$
DELIMITER ;


-- Inserimento per CBR
INSERT INTO Sintomi
VALUES (1, 1),
	(1, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (3, 3),
    (3, 4),
    (4, 4),
    (4, 5),
    (4, 6),
    (5, 7),
    (5, 8);
    
INSERT INTO Soluzioni
VALUES (1, 1),
    (2, 1),
    (2, 2),
    (3, 3),
    (3, 4),
    (4, 4),
    (4, 5),
    (5, 6);

-- Primo Inserimento
INSERT INTO NuoviSintomi(Sintomo)
VALUES (1), (2), (3);

CALL RetrieveReuse();

INSERT INTO RimediUtilizzati(Rimedio)
VALUES (4), (5), (6);

CALL ReviseRetain();

-- Secondo Inserimento
INSERT INTO NuoviSintomi(Sintomo)
VALUES (1), (3), (5);

CALL RetrieveReuse();

INSERT INTO RimediUtilizzati(Rimedio)
VALUES (3), (5), (7);

CALL ReviseRetain();

-- Terzo Inserimento
INSERT INTO NuoviSintomi(Sintomo)
VALUES (4), (5), (7);

CALL RetrieveReuse();

INSERT INTO RimediUtilizzati(Rimedio)
VALUES (4), (5), (6);

CALL ReviseRetain();