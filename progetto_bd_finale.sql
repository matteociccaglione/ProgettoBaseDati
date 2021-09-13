-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema progetto1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `progetto1` ;

-- -----------------------------------------------------
-- Schema progetto1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `progetto1` DEFAULT CHARACTER SET utf8 ;
USE `progetto1` ;

-- -----------------------------------------------------
-- Table `progetto1`.`film`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`film` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`film` (
  `Titolo` VARCHAR(60) NOT NULL,
  `Regista` VARCHAR(45) NOT NULL,
  `Tipo` ENUM("other", "nuovo", "classico") NOT NULL COMMENT 'Must be: Other, New or Classic',
  `AnnoPubblicazione` YEAR NOT NULL,
  `Costo` DECIMAL NOT NULL,
  PRIMARY KEY (`Titolo`, `Regista`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`attore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`attore` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`attore` (
  `FilmTitolo` VARCHAR(60) NOT NULL,
  `FilmRegista` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FilmTitolo`, `FilmRegista`, `Nome`),
  INDEX `Film_idx` (`FilmTitolo` ASC, `FilmRegista` ASC) VISIBLE,
  CONSTRAINT `FilmRecitato`
    FOREIGN KEY (`FilmTitolo` , `FilmRegista`)
    REFERENCES `progetto1`.`film` (`Titolo` , `Regista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`centro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`centro` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`centro` (
  `Codice` INT NOT NULL AUTO_INCREMENT,
  `Indirizzo` VARCHAR(60) NOT NULL,
  `Responsabile` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`cliente` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`cliente` (
  `CF` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data di Nascita` DATE NOT NULL,
  PRIMARY KEY (`CF`),
  UNIQUE INDEX `CF_UNIQUE` (`CF` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`emailcentro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`emailcentro` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`emailcentro` (
  `Centro` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Centro`, `Email`),
  CONSTRAINT `CentroAppartenenza`
    FOREIGN KEY (`Centro`)
    REFERENCES `progetto1`.`centro` (`Codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`settore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`settore` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`settore` (
  `Codice` INT NOT NULL,
  `Centro` INT NOT NULL,
  INDEX `Centro_idx` (`Centro` ASC) VISIBLE,
  PRIMARY KEY (`Codice`, `Centro`),
  CONSTRAINT `Centro`
    FOREIGN KEY (`Centro`)
    REFERENCES `progetto1`.`centro` (`Codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`filmeffettivo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`filmeffettivo` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`filmeffettivo` (
  `FilmTitolo` VARCHAR(60) NOT NULL,
  `FilmRegista` VARCHAR(45) NOT NULL,
  `SettoreCodice` INT NOT NULL,
  `SettoreCentro` INT NOT NULL,
  `numCopie` INT NOT NULL,
  `posizione` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`),
  INDEX `Settore_idx` (`SettoreCentro` ASC, `SettoreCodice` ASC) VISIBLE,
  CONSTRAINT `Settore`
    FOREIGN KEY (`SettoreCentro` , `SettoreCodice`)
    REFERENCES `progetto1`.`settore` (`Centro` , `Codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Film`
    FOREIGN KEY (`FilmTitolo` , `FilmRegista`)
    REFERENCES `progetto1`.`film` (`Titolo` , `Regista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`login`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`login` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`login` (
  `username` VARCHAR(45) NOT NULL,
  `passw` VARCHAR(33) NOT NULL,
  `ruolo` ENUM("impiegato", "manager", "amministratore") NOT NULL,
  PRIMARY KEY (`username`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto1`.`impiegato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`impiegato` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`impiegato` (
  `CF` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Recapito` VARCHAR(45) NOT NULL,
  `TitolodiStudio` VARCHAR(60) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CF`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  CONSTRAINT `userkey`
    FOREIGN KEY (`username`)
    REFERENCES `progetto1`.`login` (`username`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`impiego`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`impiego` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`impiego` (
  `Impiegato` VARCHAR(45) NOT NULL,
  `DataInizio` DATE NOT NULL,
  `DataFine` DATE NULL DEFAULT NULL,
  `Ruolo` VARCHAR(45) NOT NULL,
  `Centro` INT NOT NULL,
  PRIMARY KEY (`Impiegato`, `DataInizio`),
  INDEX `Centro_idx` (`Centro` ASC) VISIBLE,
  CONSTRAINT `CentroDiImpiego`
    FOREIGN KEY (`Centro`)
    REFERENCES `progetto1`.`centro` (`Codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Impiegato`
    FOREIGN KEY (`Impiegato`)
    REFERENCES `progetto1`.`impiegato` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`noleggia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`noleggia` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`noleggia` (
  `Cliente` VARCHAR(45) NOT NULL,
  `FilmTitolo` VARCHAR(60) NOT NULL,
  `FilmRegista` VARCHAR(45) NOT NULL,
  `SettoreCodice` INT NOT NULL,
  `SettoreCentro` INT NOT NULL,
  `DataScadenza` DATE NOT NULL,
  PRIMARY KEY (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`),
  INDEX `FilmNoleggiato_idx` (`FilmTitolo` ASC, `FilmRegista` ASC, `SettoreCodice` ASC, `SettoreCentro` ASC) VISIBLE,
  INDEX `Cliente_idx` (`Cliente` ASC) VISIBLE,
  CONSTRAINT `FilmNoleggiato`
    FOREIGN KEY (`FilmTitolo` , `FilmRegista` , `SettoreCodice` , `SettoreCentro`)
    REFERENCES `progetto1`.`filmeffettivo` (`FilmTitolo` , `FilmRegista` , `SettoreCodice` , `SettoreCentro`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `progetto1`.`cliente` (`CF`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`turno di lavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`turno di lavoro` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`turno di lavoro` (
  `DataInizio` DATE NOT NULL,
  `Impiegato` VARCHAR(45) NOT NULL,
  `DataFine` DATE NULL,
  PRIMARY KEY (`DataInizio`, `Impiegato`),
  INDEX `ImpiegoLavoro_idx` (`Impiegato` ASC) VISIBLE,
  CONSTRAINT `ImpiegoLavoro`
    FOREIGN KEY (`Impiegato`)
    REFERENCES `progetto1`.`impiegato` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`orariogiornaliero`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`orariogiornaliero` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`orariogiornaliero` (
  `Giorno` ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') NOT NULL,
  `TurnoDiLavoroI` VARCHAR(45) NOT NULL,
  `TurnoDiLavoroData` DATE NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NOT NULL COMMENT 'Non Capisco perchè time non funziona.',
  PRIMARY KEY (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`),
  INDEX `turnodilavoro_idx` (`TurnoDiLavoroI` ASC, `TurnoDiLavoroData` ASC) VISIBLE,
  CONSTRAINT `turnodilavoro`
    FOREIGN KEY (`TurnoDiLavoroI` , `TurnoDiLavoroData`)
    REFERENCES `progetto1`.`turno di lavoro` (`Impiegato` , `DataInizio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`telefonocentro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`telefonocentro` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`telefonocentro` (
  `Centro` INT NOT NULL,
  `Numero` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Centro`, `Numero`),
  CONSTRAINT `CentroApp`
    FOREIGN KEY (`Centro`)
    REFERENCES `progetto1`.`centro` (`Codice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `progetto1`.`remake`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`remake` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`remake` (
  `FilmTitolo1` VARCHAR(60) NOT NULL,
  `FilmRegista1` VARCHAR(45) NOT NULL,
  `FilmTitolo2` VARCHAR(60) NOT NULL,
  `FilmRegista2` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FilmTitolo1`, `FilmRegista1`, `FilmTitolo2`, `FilmRegista2`),
  INDEX `FilmRiferito2_idx` (`FilmTitolo2` ASC, `FilmRegista2` ASC) VISIBLE,
  CONSTRAINT `FilmRiferito`
    FOREIGN KEY (`FilmTitolo1` , `FilmRegista1`)
    REFERENCES `progetto1`.`film` (`Titolo` , `Regista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FilmRiferito2`
    FOREIGN KEY (`FilmTitolo2` , `FilmRegista2`)
    REFERENCES `progetto1`.`film` (`Titolo` , `Regista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto1`.`telefonocliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`telefonocliente` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`telefonocliente` (
  `Cliente` VARCHAR(45) NOT NULL,
  `Numero` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Cliente`, `Numero`),
  CONSTRAINT `ClienteTel`
    FOREIGN KEY (`Cliente`)
    REFERENCES `progetto1`.`cliente` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto1`.`emailcliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`emailcliente` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`emailcliente` (
  `Cliente` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Cliente`, `Email`),
  CONSTRAINT `ClienteE`
    FOREIGN KEY (`Cliente`)
    REFERENCES `progetto1`.`cliente` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto1`.`reportOre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`reportOre` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`reportOre` (
  `DataInizio` DATE NOT NULL,
  `Impiegato` VARCHAR(45) NOT NULL,
  `Ore` DECIMAL NOT NULL DEFAULT 0,
  `DataFine` DATE NULL COMMENT 'Tabella necessaria per memorizzare esattamente quante ore l\'impiegato ha lavorato in quale mese. N.B. DataFine può essere il 31 del mese oppure un valore prima se l\'impiegato cambia centro di lavoro nel mentre.',
  PRIMARY KEY (`DataInizio`, `Impiegato`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto1`.`indirizzo cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progetto1`.`indirizzo cliente` ;

CREATE TABLE IF NOT EXISTS `progetto1`.`indirizzo cliente` (
  `Cliente` VARCHAR(45) NOT NULL,
  `Indirizzo` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`Cliente`, `Indirizzo`),
  CONSTRAINT `Cliente_Indirizzo_FK`
    FOREIGN KEY (`Cliente`)
    REFERENCES `progetto1`.`cliente` (`CF`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `progetto1` ;

-- -----------------------------------------------------
-- procedure noleggiaFilm
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`noleggiaFilm`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `noleggiaFilm` (in var_Cliente varchar(45), in var_Titolo varchar(60), in var_Regista varchar(45), in var_Settore INT, in var_DataS DATE, in var_Username VARCHAR(45))
BEGIN
	declare var_Centro INT;
    declare var_Impiegato varchar(45);
    declare numero int;
    declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
	set autocommit=0;
    set transaction isolation level repeatable read;
    start transaction;
		select CF from `impiegato` where username=var_Username into var_Impiegato;
		select Centro from `impiego` where Impiegato=var_Impiegato and DataFine is null into var_Centro; 
        select numCopie from `filmeffettivo` where FilmTitolo=var_Titolo and FilmRegista=var_Regista and SettoreCentro=var_Centro and SettoreCodice=var_Settore into numero;
        if(numero<=0)
		then
			signal sqlstate '45001' set message_text=" Non ci sono copie disponibili";
		end if;
		update `filmeffettivo`
        set numCopie=numero-1
        where FilmTitolo=var_Titolo and FilmRegista=var_Regista and SettoreCentro=var_Centro and SettoreCodice=var_Settore;
        insert into noleggia(Cliente,FilmTitolo,FilmRegista,SettoreCodice,SettoreCentro,DataScadenza)
        values(var_Cliente,var_Titolo,var_Regista,var_Settore,var_Centro,var_DataS);
        commit;
        set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registraImpiego
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`registraImpiego`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `registraImpiego` (in var_Impiegato VARCHAR(45), in var_Centro INT,  in var_Ruolo VARCHAR(45), in list_day VARCHAR(150), in list_hour VARCHAR(150))
BEGIN
	declare old_Centro INT;
	declare exit handler for sqlexception
    begin
		rollback;
		set autocommit = 1;
        resignal;
	end;
    set autocommit=0;
    set transaction isolation level repeatable read;
    start transaction;
    select Centro from `impiego` where Impiegato=var_Impiegato and DataFine is null into old_Centro;
	update `impiego`
    set DataFine=curdate()
    where Impiegato=var_Impiegato and DataFine is null;
    insert into `impiego` (Impiegato,DataInizio,DataFine,Ruolo,Centro)
    values(var_Impiegato,curdate(),null,var_Ruolo,var_Centro);
    call _InserisciTurno(var_Impiegato,list_day,list_hour);
    if (var_Centro<>old_Centro)
    /*
		Questo indica un cambiamento nel luogo di lavoro quindi lo registro.
    */
    then
		update `reportOre`
        set DataFine=curdate()
        where Impiegato=var_Impiegato and DataFine is null;
        insert into `reportOre` (Impiegato,DataInizio,DataFine,Ore) values (var_Impiegato,curdate(),NULL,0);
	end if;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciTurnoDiLavoro
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciTurnoDiLavoro`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciTurnoDiLavoro` (in var_Impiegato VARCHAR(45), in list_day VARCHAR(150), in list_hour VARCHAR(150))
BEGIN
	declare exit handler for sqlexception
    begin
		rollback;
        set autocommit=1;
        resignal;
	end;
    set autocommit=0;
    set transaction isolation level repeatable read;
    start transaction;
	call _InserisciTurno(var_Impiegato,list_day,list_hour);
    if (not exists (select * from `reportOre` where Impiegato=var_Impiegato and DataFine is null))
    then
		insert into `reportOre` (Impiegato,DataInizio,DataFine,Ore) values (var_Impiegato,curdate(),NULL,0);
	end if;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure timbra
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`timbra`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `timbra` (in var_username varchar(45))
BEGIN
	declare var_nuovo time default null;
    declare var_Impiegato varchar(45);
            declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
	set autocommit=0;
    set transaction isolation level repeatable read;
    start transaction;
    create  table if not exists `timbratura`(
		Impiegato VARCHAR(45) PRIMARY KEY,
        TimeInizio TIME,
        TimeFine TIME
        );
    select CF from `impiegato` where username=var_username into var_Impiegato;
    select timeInizio from `timbratura` where Impiegato=var_Impiegato into var_nuovo;
    if(var_nuovo is null)
    then
		insert into `timbratura` values(var_Impiegato,curtime(),NULL);
	else
        update `timbratura`
        set  timeFine=curtime()
        where Impiegato=var_Impiegato;
	end if;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciCentro
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciCentro`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciCentro` (in var_Indirizzo varchar(60),in var_Resp varchar(45), in var_Telefono varchar(100), in var_Email varchar(450) )
BEGIN
	declare var_Centro int;
    declare var_A int;
    declare var_S varchar(45);
            declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end; 
	set autocommit=0;
    set transaction isolation level read uncommitted;
    start transaction;
    if(var_Email ='' or var_Telefono ='')
    then
		signal sqlstate '45001' set message_text="Devi inserire almeno una email e un telefono";
	end if;
    insert into `centro`(Indirizzo,Responsabile)
    values (var_Indirizzo,var_Resp);
    set var_Centro=last_insert_id();
    set var_A = 0;
    insert_loop1: loop
    select SPLIT_STR(var_Email,";",var_A) into var_S;
    if(var_S= '')
		then
        leave insert_loop1;
	end if;
	insert into `emailcentro` (Centro,Email)
    values (var_Centro,var_S);
    set var_A = var_A+1;
    end loop;
    set var_A = 0;
    insert_loop2: loop
    select SPLIT_STR(var_Telefono,";",var_A) into var_S;
    if(var_S = '')
    then
		leave insert_loop2;
	end if;
    insert into `telefonocentro` (Centro,Numero)
    values (var_Centro,var_S);
    set var_A = var_A +1;
    end loop;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciSettore
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciSettore`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciSettore` (in var_S INT, in var_C INT)
BEGIN
    insert into `settore` values(var_S,var_C);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registraImpiegato
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`registraImpiegato`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `registraImpiegato` (in var_CF VARCHAR(45), in var_Nome VARCHAR(45), in var_Recapito VARCHAR(45), in var_TitolodiStudio VARCHAR(60), in var_Username VARCHAR(45),in var_Password VARCHAR(45), in list_day VARCHAR(150), in list_hour VARCHAR(150), in var_Centro INT, in var_Ruolo VARCHAR(45),in var_Cognome VARCHAR(45))
BEGIN
	declare exit handler for sqlexception
    begin
		rollback;
        set autocommit = 1;
        resignal;
	end;
	set autocommit=0;
    set transaction isolation level read committed;
    START TRANSACTION;
		insert into `login` values(var_Username,md5(var_Password),"impiegato");
		insert into `impiegato` values(var_CF,var_Nome,var_Recapito,var_TitolodiStudio,var_Username,var_Cognome);
		update `impiego`
		set DataFine=curdate()
		where Impiegato=var_CF and DataFine is null;
		insert into `impiego` (Impiegato,DataInizio,DataFine,Ruolo,Centro)
		values(var_CF,curdate(),null,var_Ruolo,var_Centro);
		call _InserisciTurno(var_CF,list_day,list_hour);
        commit;
	set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registraCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`registraCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `registraCliente` (in var_CF VARCHAR(45), in var_Nome VARCHAR(45), in var_Indirizzi VARCHAR(300),in var_Cognome VARCHAR(45),in var_Telefoni VARCHAR(100), in var_Email VARCHAR(200),in var_DataNascita DATE )
BEGIN
	declare contA int default 1;
    declare var_T VARCHAR(45);
    declare var_E VARCHAR(45);
    declare var_I VARCHAR(60);
        declare exit handler for sqlexception
		begin
			rollback;
            set autocommit = 1;
            resignal;
		end; 
	set autocommit=0;
    set transaction isolation level read uncommitted;
    start transaction;
    if(var_Telefoni = '' and var_Email = '')
    then
		signal sqlstate '45001' set message_text="Devi fornire almeno uno tra telefoni ed email";
	end if;
    if(var_Indirizzi='')
    then
		signal sqlstate '45001' set message_text="Devi fornire almeno un indirizzo";
	end if;
	insert into `cliente` values(var_CF,var_Nome,var_Cognome,var_DataNascita);
    insert_loop1: loop
	select SPLIT_STR(var_Telefoni,";",contA) into var_T;
    if(var_T='')
		then leave insert_loop1;
	end if;
    insert into `telefonocliente` values(var_CF,var_T);
    set contA=contA+1;
    end loop;
    set contA=1;
    insert_loop2: loop
    select SPLIT_STR(var_Email,";",contA) into var_E;
    if(var_E='')
		then leave insert_loop2;
	end if;
    insert into `emailcliente` values(var_CF,var_E);
    set contA=contA+1;
    end loop;
    set contA =1;
    insert_loop3: loop
    select SPLIT_STR(var_Indirizzi,";",contA) into var_I;
    if(var_I = '')
		then leave insert_loop3;
	end if;
    insert into `indirizzo cliente` values (var_CF,var_I);
    set contA = contA+1;
    end loop;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure reportMensile
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`reportMensile`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `reportMensile` (in var_Impiegato VARCHAR(45), in var_Month SMALLINT, in var_Year SMALLINT)
BEGIN
		declare var_Centro INT;
        declare var_Data date;
        declare done int default false;
		declare cur2 cursor for 
        select `turno di lavoro`.`DataInizio` from `turno di lavoro` where 
        MONTH(`turno di lavoro`.`DataInizio`)=var_Month and `turno di lavoro`.`Impiegato`=var_Impiegato;
 /*       declare cur cursor for 
        select `Centro` from `impiego` where `impiego`.`Impiegato`=var_Impiegato and MONTH(`impiego`.`DataInizio`)<=var_Month and (MONTH(`impiego`.`DataFine`)>=var_Month or `impiego`.`DataFine` is null);
    */  declare continue handler for not found set done = true;

	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        set autocommit=1;
        resignal;  -- raise again the sql exception to the caller
    end;
    drop temporary table if exists `centroOre` ;
    create temporary table `centroOre`(
		`centro` INT ,
        `Ore` DECIMAL
        );
	set transaction isolation level serializable;
    set autocommit=0;
    start transaction;
/*    open cur;
    read_loop: loop
		fetch cur into var_Centro;
        if done 
        then leave read_loop;
        end if;
        */
        insert into `centroOre`
        select `Centro`,sum(`Ore`)
        from `impiego` join `reportOre` on `impiego`.`Impiegato`=`reportOre`.`Impiegato`
        where `impiego`.`Impiegato`=var_Impiegato and
        MONTH(`impiego`.`DataInizio`)<=var_Month and 
        `reportOre`.`DataInizio`>=`impiego`.`DataInizio` and (`reportOre`.`DataFine`<=`impiego`.`DataFine` or `impiego`.`DataFine` is null) and MONTH(`reportOre`.`DataInizio`)=var_Month and YEAR(`reportOre`.`DataInizio`)=var_Year
        group by `Centro`;
    /*    end loop;
        close cur;*/
        select `centro`.`Codice`, `centro`.`Indirizzo`, `centroOre`.`Ore`  from `centroOre` join `centro` on `centroOre`.`centro`=`centro`.`Codice`;
        set done=false;
        open cur2;
other_loop: loop
		fetch cur2 into var_Data;
        if done
        then 
			leave other_loop;
		end if;
        select `turno di lavoro`.`DataInizio`,`turno di lavoro`.`DataFine` from `turno di lavoro` where `turno di lavoro`.`DataInizio`=var_Data and `turno di lavoro`.`Impiegato`=var_Impiegato; 
        select `orariogiornaliero`.`Giorno`, `orariogiornaliero`.`OraInizio`, `orariogiornaliero`.`OraFine` from
        `orariogiornaliero` where `orariogiornaliero`.`TurnoDiLavoroData`=var_Data and `orariogiornaliero`.`TurnoDiLavoroI`=var_Impiegato;
        end loop;
        close cur2;
        commit;
        drop temporary table `centroOre`;
        set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure creaUtente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`creaUtente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `creaUtente` (in var_Username VARCHAR(45), in var_Password VARCHAR(45), in var_Role ENUM("impiegato","manager","amministratore"))
BEGIN
	insert into `login` values (var_Username,md5(var_Password),var_Role);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`login`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `login` (in var_Username VARCHAR(45), in var_Password VARCHAR(45), out var_Role INT)
BEGIN
		declare var_User ENUM("amministratore","impiegato","manager");
		select ruolo from `login` where username=var_Username and passw=md5(var_Password) into var_User;
        if(var_User = "amministratore")
        then
			set var_Role=1;
		else
			if(var_User="impiegato")
            then set var_Role=2;
            else
				if(var_User="manager")
                then set var_Role=3;
                else
					set var_Role=4;
                    end if;
                    end if;
                    end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserireFilmCatalogo
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserireFilmCatalogo`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserireFilmCatalogo` (in var_Titolo VARCHAR(60), in var_Regista VARCHAR(45), in var_Tipo ENUM("other","nuovo","classico"),in var_Anno DATE, in var_Attori VARCHAR(1000),in var_Costo DOUBLE,in var_RemakeTitoli VARCHAR(600), in var_RemakeRegista VARCHAR(450))
BEGIN
	declare var_Actor VARCHAR(45);
    declare var_Titolo1 VARCHAR(45);
    declare var_Regista1 VARCHAR(45);
    declare contA int default 1;
            declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
    set autocommit=0;
    set transaction isolation level read uncommitted;
    start transaction;
		insert into `film` values (var_Titolo,var_Regista,var_Tipo,YEAR(var_Anno),var_Costo);
		insert_loop: loop
			select SPLIT_STR(var_Attori,";",contA) into var_Actor;
			if(var_Actor='')
				then leave insert_loop;
			end if;
			insert into `attore` values(var_Titolo,var_Regista,var_Actor);
			set contA=contA+1;
		end loop;
        set contA=1;
        insert2_loop:loop
			select SPLIT_STR(var_RemakeTitoli,";",contA) into var_Titolo1;
            select SPLIT_STR(var_RemakeRegista,";",contA) into var_Regista1;
            if(var_Titolo1='' or var_Regista1='')
				then leave insert2_loop;
			end if;
            insert into `remake` values(var_Titolo,var_Regista,var_Titolo1,var_Regista1);
            set contA=contA+1;
		end loop;
        commit;
	set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciFilmSettore
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciFilmSettore`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciFilmSettore` (in var_Titolo VARCHAR(60), in var_Regista VARCHAR(45), in var_Settore INT,in var_Username varchar(45), in var_Copie INT, in var_posizione VARCHAR(45))
BEGIN
	declare var_Centro int;
    declare var_Impiegato varchar(45);
   	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        set autocommit=1;
        resignal;  -- raise again the sql exception to the caller
    end;
    set transaction isolation level read committed;
    set autocommit = 0;
    start transaction;
    select CF from `impiegato` where username=var_Username into var_Impiegato;
    select Centro from `impiego` where Impiegato=var_Impiegato and DataFine is null into var_Centro;
	insert into `filmeffettivo` values (var_Titolo, var_Regista, var_Settore,var_Centro, var_Copie, var_Posizione);
    commit;
    set autocommit = 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure stampaFilmScaduti
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`stampaFilmScaduti`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `stampaFilmScaduti` ()
BEGIN
		
        set transaction read only;
        set transaction isolation level repeatable read;
        set autocommit=0;
        start transaction;
			select `centro`.`Codice`, `noleggia`.`FilmTitolo`, `noleggia`.`Cliente`,`cliente`.`Nome`,`cliente`.`Cognome`
				from `noleggia` join `centro` on `noleggia`.`SettoreCentro`=`centro`.`Codice` join `cliente` on `noleggia`.`Cliente`=`cliente`.`CF`
                where `noleggia`.`DataScadenza`<curdate();
			commit;
		set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure restituisciFilm
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`restituisciFilm`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `restituisciFilm` (in var_Cliente VARCHAR(45), in var_Titolo VARCHAR(60), in var_Regista VARCHAR(45), in var_Settore VARCHAR(45), in var_Username VARCHAR(45))
BEGIN
		declare var_Centro int;
        declare var_Impiegato varchar(45);
            declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
        set autocommit=0;
        start transaction;
        select CF from `impiegato` where username=var_Username into var_Impiegato;
		select Centro from `impiego` where Impiegato=var_Impiegato and DataFine is null into var_Centro;
		delete from `noleggia` where Cliente=var_Cliente and FilmTitolo=var_Titolo and FilmRegista=var_Regista and SettoreCodice=var_Settore and SettoreCentro=var_Centro;
        update `filmeffettivo` set numCopie=numCopie+1 where FilmTitolo=var_Titolo and FilmRegista=var_Regista and SettoreCodice=var_Settore and SettoreCentro=var_Centro;
        commit;
        set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function SPLIT_STR
-- -----------------------------------------------------

USE `progetto1`;
DROP function IF EXISTS `progetto1`.`SPLIT_STR`;

DELIMITER $$
USE `progetto1`$$
CREATE FUNCTION  SPLIT_STR(
		x VARCHAR(255),
		delim VARCHAR(12),
		pos INT
	)
	RETURNS VARCHAR(255)
	RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
	LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
	delim, '');$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaImpiegati
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaImpiegati`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaImpiegati` ()
BEGIN
	select * from `impiegato`;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaCentri
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaCentri`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaCentri` ()
BEGIN
	select * from `centro`;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaTurno
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaTurno`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaTurno` (in var_Username VARCHAR(45))
BEGIN
	declare var_Imp VARCHAR(45);
    declare var_T DATE;
        declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
    set autocommit=0;
    set transaction read only;
    start transaction;
    select CF from `impiegato` where username=var_Username into var_Imp;
    select DataInizio from `turno di lavoro` where Impiegato=var_Imp and DataFine is null into var_T;
    select Giorno, OraInizio, OraFine 
    from `orariogiornaliero` where TurnoDiLavoroI=var_Imp and TurnoDiLavoroData=var_T;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaFilmCentro
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaFilmCentro`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaFilmCentro` (in var_Username varchar(45))
BEGIN
	declare var_Impiegato varchar(45);
    declare var_Centro int;
    select CF from `impiegato` where username=var_Username into var_Impiegato;
    select Centro from `impiego` where Impiegato=var_Impiegato and DataFine is null into var_Centro;
    select FilmTitolo as `Titolo`,FilmRegista as `Regista`,SettoreCodice as `Settore`,numCopie as `Numero di copie`,posizione as `Posizione`,costo as `Costo`  from `filmeffettivo` join `film` on FilmTitolo = Titolo and FilmRegista = Regista where SettoreCentro=var_Centro;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure reportAnnuale
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`reportAnnuale`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `reportAnnuale` (in var_Impiegato varchar(45), in var_Year SMALLINT,in var_Turno BOOL)
BEGIN
	declare var_Centro INT;
    declare var_Data DATE;
        declare done int default false;
        declare cur2 cursor for 
        select `turno di lavoro`.`DataInizio` from `turno di lavoro` where 
        YEAR(`turno di lavoro`.`DataInizio`)=var_Year and `turno di lavoro`.`Impiegato`=var_Impiegato;
        declare cur cursor for 
        select distinct `Centro` from `impiego` where `impiego`.`Impiegato`=var_Impiegato and YEAR(`impiego`.`DataInizio`)=var_Year;
        declare continue handler for not found set done = true;

	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
		set autocommit=1;
        resignal;  -- raise again the sql exception to the caller
    end;
    drop temporary table if exists `centroOre` ;
    create temporary table `centroOre`(
		`centro` INT PRIMARY KEY,
        `Ore` NUMERIC
        );
	set transaction isolation level serializable;
    set autocommit=0;
    start transaction;
    open cur;
    read_loop: loop
		fetch cur into var_Centro;
        if done 
        then leave read_loop;
        end if;
        insert into `centroOre`
        select  `Centro`,sum(`Ore`)
        from `impiego` join `reportOre` on `impiego`.`Impiegato`=`reportOre`.`Impiegato`
        where `Centro`=var_Centro and `impiego`.`Impiegato`=var_Impiegato and
        YEAR(`impiego`.`DataInizio`)=var_Year and 
        `reportOre`.`DataInizio`>=`impiego`.`DataInizio` and (`reportOre`.`DataFine`<=`impiego`.`DataFine` or `impiego`.`DataFine` is null)
        group by `Centro`;
        end loop;
        close cur;
			select `centro`.`Codice`, `centro`.`Indirizzo`, `centroOre`.`Ore`  from `centroOre` join `centro` on `centroOre`.`centro`=`centro`.`Codice`;
					set done=false;
		if(var_Turno)
        then
			open cur2;
	other_loop: loop
			fetch cur2 into var_Data;
			if done
			then 
				leave other_loop;
			end if;
			select `turno di lavoro`.`DataInizio`,`turno di lavoro`.`DataFine` from `turno di lavoro` where `turno di lavoro`.`DataInizio`=var_Data and `turno di lavoro`.`Impiegato`=var_Impiegato; 
			select `orariogiornaliero`.`Giorno`, `orariogiornaliero`.`OraInizio`, `orariogiornaliero`.`OraFine` from
			`orariogiornaliero` where `orariogiornaliero`.`TurnoDiLavoroData`=var_Data and `orariogiornaliero`.`TurnoDiLavoroI`=var_Impiegato;
			end loop;
			close cur2;
		end if;
        commit;
        drop temporary table `centroOre`;
        set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rimuoviFilm
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`rimuoviFilm`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `rimuoviFilm` (in var_FilmTitolo VARCHAR(60), in var_FilmRegista VARCHAR(45))
BEGIN
	delete from film where Titolo=var_FilmTitolo and Regista=var_FilmRegista;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rimuoviManager
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`rimuoviManager`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `rimuoviManager` (in var_Username VARCHAR(45))
BEGIN
	delete from login where username=var_Username and ruolo="manager";
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rimuoviImpiegato
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`rimuoviImpiegato`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `rimuoviImpiegato` (in var_Username VARCHAR(45))
BEGIN
	delete from login where username=var_Username and ruolo="impiegato";
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rimuoviFilmSettore
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`rimuoviFilmSettore`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `rimuoviFilmSettore` (in var_Titolo VARCHAR(60), in var_Regista VARCHAR(45), in var_Settore INT, in var_Username VARCHAR(45))
BEGIN
	declare var_Centro int;
    declare var_CF VARCHAR(45);
        declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;            
            resignal;
		end;
	set autocommit = 0;
    set transaction isolation level read committed;
    start transaction;
    select CF from `impiegato` where username=var_Username into var_CF;
    select Centro from `impiego` where Impiegato=var_CF and DataFine is null into var_Centro;
    delete from `filmeffettivo` where FilmTitolo=var_Titolo and FilmRegista=var_Regista and SettoreCodice=var_Settore and SettoreCentro=var_Centro;
    commit;
    set autocommit = 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure _InserisciTurno
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`_InserisciTurno`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `_InserisciTurno` (in var_Impiegato VARCHAR(45), in list_day VARCHAR(150), in list_hour VARCHAR(150))
BEGIN
	declare cont int default 1;
    declare contH int default 1;
	declare impiegoDataInizio date;
    declare var_Day varchar(45);
    declare var_HourS time;
    declare var_HourE time;
    if(list_day='' or list_hour='')
    then
		signal sqlstate '45001' set message_text="Devi inserire almeno un giorno e almeno un orario";
	end if;
	update `turno di lavoro`
    set DataFine=curdate()
    where Impiegato=var_Impiegato and DataFine is null;
    insert into `turno di lavoro` (DataInizio,Impiegato)
    values (curdate(),var_Impiegato);
    insert_loop: loop
		select SPLIT_STR(list_day,";",cont) into var_Day;
        if(var_Day='')
			then leave insert_loop;
		end if;
		select SPLIT_STR(list_hour,";",contH) into var_HourS;
		select SPLIT_STR(list_hour,";",contH+1) into var_HourE;
		insert into `orariogiornaliero` values (var_Day,var_Impiegato,curdate(),var_HourS,var_HourE);
		set cont=cont+1;
		set contH=contH+2;
	end loop;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure trovaCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`trovaCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `trovaCliente` (in var_Cliente VARCHAR(45))
BEGIN
	set autocommit = 0;
    set transaction read only;
    set transaction isolation level read committed;
    start transaction;
	select * from `cliente` where `cliente`.`CF`=var_Cliente;
    select Numero from `telefonocliente` where `telefonocliente`.`Cliente`=var_Cliente;
    select Email from `emailcliente` where `emailcliente`.`Cliente`=var_Cliente;
    select Indirizzo from `indirizzo cliente` where `indirizzo cliente`.`Cliente` =var_Cliente;
    select FilmTitolo,FilmRegista,DataScadenza from `noleggia` where `noleggia`.`Cliente`=var_Cliente;
    commit;
    set autocommit=1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaNoleggi
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaNoleggi`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaNoleggi` (in var_Username VARCHAR(45))
BEGIN
	declare var_Centro int;
    select Centro from impiego join impiegato on impiego.Impiegato = impiegato.CF where username=var_Username and DataFine is null into var_Centro;
	select Cliente,FilmTitolo as `Titolo`,FilmRegista as `Regista`,SettoreCodice as `Settore`,DataScadenza as `Data di Scadenza`
    from `noleggia` where SettoreCentro = var_Centro;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciEmailCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciEmailCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciEmailCliente` (in var_Email VARCHAR(45), in var_CF VARCHAR(45))
BEGIN
	insert into emailcliente values(var_CF,var_Email);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciTelefonoCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciTelefonoCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciTelefonoCliente` (in var_Telefono VARCHAR(45), in var_CF VARCHAR(45))
BEGIN
	insert into telefonocliente values(var_CF,var_Telefono);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciTelefonoCentro
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciTelefonoCentro`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciTelefonoCentro` (in var_Centro INT, in var_Telefono VARCHAR(15))
BEGIN
	       declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end; 
	insert into telefonocentro values (var_Centro,var_Telefono);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciEmailCentro
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciEmailCentro`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciEmailCentro` (in var_Centro INT, in var_Email VARCHAR(45))
BEGIN
	insert into emailcentro values (var_Centro,var_Email);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisciIndirizzoCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`inserisciIndirizzoCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `inserisciIndirizzoCliente` (in var_Indirizzo VARCHAR(60), in var_Cliente VARCHAR(45))
BEGIN
	insert into `indirizzo cliente` values (var_Cliente,var_Indirizzo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure rimuoviCliente
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`rimuoviCliente`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `rimuoviCliente` (in var_Cliente VARCHAR(45))
BEGIN
	delete from cliente where CF = var_Cliente;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiornaDisponibilita
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`aggiornaDisponibilita`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `aggiornaDisponibilita` (in var_Username VARCHAR(45), in var_Titolo VARCHAR(60), in var_Regista VARCHAR(45), in var_Settore INT, in var_Copie INT)
BEGIN
	declare var_Centro INT;
	declare exit handler for sqlexception
		begin
			rollback;
			set autocommit=1;
            resignal;
		end;
	set autocommit = 0;
    start transaction;
    select Centro from `impiego` where DataFine is null and Impiegato = (select CF from `impiegato` where username=var_Username) into var_Centro;
    update `filmeffettivo` set numCopie = numCopie + var_Copie
    where FilmTitolo = var_Titolo and FilmRegista = var_Regista and SettoreCodice = var_Settore and SettoreCentro = var_Centro;
    commit;
	set autocommit = 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizzaFilmMancanti
-- -----------------------------------------------------

USE `progetto1`;
DROP procedure IF EXISTS `progetto1`.`visualizzaFilmMancanti`;

DELIMITER $$
USE `progetto1`$$
CREATE PROCEDURE `visualizzaFilmMancanti` (in var_Username VARCHAR(45),in var_Settore INT)
BEGIN
    select * from `film` where (Titolo,Regista) not in (select FilmTitolo,FilmRegista from `filmeffettivo` where SettoreCentro = (select Centro from `impiego` where DataFine is null and Impiegato = (select CF from `impiegato` where username=var_Username)) and SettoreCodice = var_Settore);
END$$

DELIMITER ;
USE `progetto1`;

DELIMITER $$

USE `progetto1`$$
DROP TRIGGER IF EXISTS `progetto1`.`noleggia_BEFORE_INSERT` $$
USE `progetto1`$$
CREATE DEFINER = CURRENT_USER TRIGGER `progetto1`.`noleggia_BEFORE_INSERT` BEFORE INSERT ON `noleggia` FOR EACH ROW
BEGIN
	if(NEW.DataScadenza = '' or NEW.DataScadenza < curdate())
    then
		signal sqlstate '45001' set message_text="La data di scadenza deve essere successiva alla data corrente";
	end if;
END$$


USE `progetto1`$$
DROP TRIGGER IF EXISTS `progetto1`.`END_LATE_START` $$
USE `progetto1`$$
CREATE DEFINER = CURRENT_USER TRIGGER END_LATE_START BEFORE INSERT ON `orariogiornaliero` FOR EACH ROW
BEGIN
	if(new.OraFine<=new.OraInizio)
    then
		signal sqlstate '45001' set message_text="L'orario di fine deve essere successiva di almeno un minuto a quella di inizio";
	end if;
END$$


DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'login' IDENTIFIED BY 'login';

GRANT EXECUTE ON procedure `progetto1`.`login` TO 'login';
SET SQL_MODE = '';
DROP USER IF EXISTS impiegato;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'impiegato' IDENTIFIED BY 'impiegato';

GRANT EXECUTE ON procedure `progetto1`.`registraCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`noleggiaFilm` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`timbra` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`inserisciFilmSettore` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`restituisciFilm` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`stampaFilmScaduti` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaTurno` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaFilmCentro` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviFilmSettore` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`trovaCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaNoleggi` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`inserisciEmailCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`inserisciTelefonoCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`inserisciIndirizzoCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviCliente` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaFilmMancanti` TO 'impiegato';
GRANT EXECUTE ON procedure `progetto1`.`aggiornaDisponibilita` TO 'impiegato';
SET SQL_MODE = '';
DROP USER IF EXISTS manager;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'manager' IDENTIFIED BY 'manager';

GRANT EXECUTE ON procedure `progetto1`.`registraImpiego` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`registraImpiegato` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`creaUtente` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`reportMensile` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`inserisciTurnoDiLavoro` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaImpiegati` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaCentri` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`reportAnnuale` TO 'manager';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviImpiegato` TO 'manager';
SET SQL_MODE = '';
DROP USER IF EXISTS amministratore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'amministratore' IDENTIFIED BY 'amministratore';

GRANT EXECUTE ON procedure `progetto1`.`registraImpiego` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`registraImpiegato` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`creaUtente` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`reportMensile` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserisciTurnoDiLavoro` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaImpiegati` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`visualizzaCentri` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`reportAnnuale` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviImpiegato` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`creaUtente` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserisciCentro` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserisciSettore` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserireFilmCatalogo` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviManager` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`rimuoviFilm` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserisciTelefonoCentro` TO 'amministratore';
GRANT EXECUTE ON procedure `progetto1`.`inserisciEmailCentro` TO 'amministratore';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `progetto1`.`film`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Titanic', 'James Cameron', 'classico', 1997, 30);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Matrix', ' Andy e Larry Wachowski', 'other', 1999, 20);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 'classico', 1984, 15);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 'classico', 1991, 15);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Tolo Tolo', 'Checco Zalone', 'nuovo', 2020, 40);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Totò, Peppino e la... malafemmina', 'Camillo Mastrocinque', 'classico', 1956, 5);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 'other', 2001, 10);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Harry Potter e la camera dei segreti', 'Chris Columbus', 'other', 2002, 10);
INSERT INTO `progetto1`.`film` (`Titolo`, `Regista`, `Tipo`, `AnnoPubblicazione`, `Costo`) VALUES ('Pinocchio', 'Matteo Garrone', 'nuovo', 2019, 30);

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`attore`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Titanic', 'James Cameron', 'Leonardo Di Caprio');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Titanic', 'James Cameron', 'Kate Winslet');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Matrix', ' Andy e Larry Wachowski', 'Keanu Reeves');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Matrix', ' Andy e Larry Wachowski', 'Laurence Fishburne');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 'Roberto Benigni');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 'Massimo Troisi');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 'Massimo Troisi');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 'Francesca Neri');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Tolo Tolo', 'Checco Zalone', 'Checco Zalone');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Tolo Tolo', 'Checco Zalone', 'Souleymane Sylla');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Totò, Peppino e la... malafemmina', 'Camillo Mastrocinque', 'Totò');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Totò, Peppino e la... malafemmina', 'Camillo Mastrocinque', 'Peppino De Filippo');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 'Daniel Radcliffe');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 'Rupert Grint');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 'Emma Watson');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la camera dei segreti', 'Chris Columbus', 'Daniel Radcliffe');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la camera dei segreti', 'Chris Columbus', 'Rupert Grint');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Harry Potter e la camera dei segreti', 'Chris Columbus', 'Emma Watson');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Pinocchio', 'Matteo Garrone', 'Roberto Benigni');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Pinocchio', 'Matteo Garrone', 'Federico Ielapi');
INSERT INTO `progetto1`.`attore` (`FilmTitolo`, `FilmRegista`, `Nome`) VALUES ('Pinocchio', 'Matteo Garrone', 'Rocco Papaleo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`centro`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`centro` (`Codice`, `Indirizzo`, `Responsabile`) VALUES (DEFAULT, 'Via Corte Da Capo', 'Matteo');
INSERT INTO `progetto1`.`centro` (`Codice`, `Indirizzo`, `Responsabile`) VALUES (DEFAULT, 'Via Pietre Bianche', 'Siria');
INSERT INTO `progetto1`.`centro` (`Codice`, `Indirizzo`, `Responsabile`) VALUES (DEFAULT, 'Via Principale', 'Antonio');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`cliente`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`cliente` (`CF`, `Nome`, `Cognome`, `Data di Nascita`) VALUES ('CCCMTT99H15I676', 'Matteo', 'Ciccaglione', '1999-06-15');
INSERT INTO `progetto1`.`cliente` (`CF`, `Nome`, `Cognome`, `Data di Nascita`) VALUES ('BNMSRI98G47J702', 'Siria', 'Buonamano', '1998-04-16');
INSERT INTO `progetto1`.`cliente` (`CF`, `Nome`, `Cognome`, `Data di Nascita`) VALUES ('CCCMCC72H5I676', 'Marcello', 'Ciccaglione', '1972-04-05');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`emailcentro`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`emailcentro` (`Centro`, `Email`) VALUES (1, 'matteoc8@live.com');
INSERT INTO `progetto1`.`emailcentro` (`Centro`, `Email`) VALUES (2, 'siriabuonamano@outlook.it');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`settore`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (1, 1);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (2, 1);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (3, 1);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (4, 1);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (5, 1);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (1, 2);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (2, 2);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (1, 3);
INSERT INTO `progetto1`.`settore` (`Codice`, `Centro`) VALUES (2, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`filmeffettivo`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Titanic', 'James Cameron', 1, 1, 10, 'Scaffale in alto');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Titanic', 'James Cameron', 2, 2, 5, 'Secondo piano');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Matrix', ' Andy e Larry Wachowski', 2, 1, 5, 'Primo piano in fondo');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Matrix', ' Andy e Larry Wachowski', 1, 3, 10, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 3, 1, 20, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 2, 3, 10, 'Scaffale a destra');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Non ci resta che piangere', 'Roberto Benigni e Massimo Troisi', 1, 2, 10, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 3, 1, 30, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 1, 2, 2, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Tolo Tolo', 'Checco Zalone', 4, 1, 25, 'In fondo a destra');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Tolo Tolo', 'Checco Zalone', 1, 3, 1, 'Vicino all\'uscita');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Totò, Peppino e la... malafemmina', 'Camillo Mastrocinque', 1, 2, 10, 'Vicino all\'uscita');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 3, 1, 40, 'Vicino all\'uscita');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Harry Potter e la pietra filosofale', 'Chris Columbus', 1, 3, 1, 'All\'ingresso');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Harry Potter e la camera dei segreti', 'Chris Columbus', 3, 1, 30, 'In fondo');
INSERT INTO `progetto1`.`filmeffettivo` (`FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `numCopie`, `posizione`) VALUES ('Pinocchio', 'Matteo Garrone', 1, 3, 5, 'In fondo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`login`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('mario98', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('marco72', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('matt', 'ce86d7d02a229acfaca4b63f01a1171b', 'manager');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('admin', 'ce86d7d02a229acfaca4b63f01a1171b', 'amministratore');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('franco', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('giuseppe', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('luigi', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('fabio', 'ce86d7d02a229acfaca4b63f01a1171b', 'impiegato');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('alex', 'ce86d7d02a229acfaca4b63f01a1171b', 'manager');
INSERT INTO `progetto1`.`login` (`username`, `passw`, `ruolo`) VALUES ('matteo', 'ce86d7d02a229acfaca4b63f01a1171b', 'amministratore');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`impiegato`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('SMI89DMRD007', 'Mario', '3348993006', 'Laurea in Medicina', 'mario98', 'Rossi');
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('CTF0483IMN42', 'Marco', '3278977455', 'Laurea in Ingegneria ', 'marco72', 'Verdi');
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('FRCMLN893IMN42', 'Franco', '3457898231', 'Diploma', 'franco', 'Magno');
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('GSPXXS986HJK52', 'Giuseppe', '3246789002', 'Diploma', 'giuseppe', 'Filiberto');
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('LGXFDR993HGN58', 'Luigi', '3339944002', 'Terza media', 'luigi', 'Griguoli');
INSERT INTO `progetto1`.`impiegato` (`CF`, `Nome`, `Recapito`, `TitolodiStudio`, `username`, `Cognome`) VALUES ('FBXMLN89HDS78', 'Fabio', 'fabio@gmail.com', 'Laurea', 'fabio', 'Tarantino');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`impiego`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('SMI89DMRD007', '2021-04-01', '2021-05-01', 'prova', 1);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('CTF0483IMN42', '2021-04-01', '2021-05-01', 'magaziniere', 1);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('CTF0483IMN42', '2021-05-01', NULL, 'magaziniere', 3);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('FRCMLN893IMN42', '2021-06-01', NULL, 'magaziniere', 2);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('GSPXXS986HJK52', '2021-04-01', '2021-05-01', 'cassiere', 3);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('GSPXXS986HJK52', '2021-05-01', NULL, 'cassiere', 1);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('LGXFDR993HGN58', '2021-05-01', '2021-06-01', 'magaziniere', 1);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('LGXFDR993HGN58', '2021-06-01', NULL, 'cassiere', 1);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('FBXMLN89HDS78', '2021-05-01', NULL, 'cassiere', 3);
INSERT INTO `progetto1`.`impiego` (`Impiegato`, `DataInizio`, `DataFine`, `Ruolo`, `Centro`) VALUES ('SMI89DMRD007', '2021-05-01', NULL, 'cassiere', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`noleggia`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`noleggia` (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `DataScadenza`) VALUES ('CCCMTT99H15I676', 'Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 3, 1, '2021-06-28');
INSERT INTO `progetto1`.`noleggia` (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `DataScadenza`) VALUES ('CCCMCC72H5I676', 'Pensavo fosse amore... invece era un calesse', 'Massimo Troisi', 3, 1, '2021-06-19');
INSERT INTO `progetto1`.`noleggia` (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `DataScadenza`) VALUES ('CCCMTT99H15I676', 'Harry Potter e la pietra filosofale', 'Chris Columbus', 1, 3, '2021-07-01');
INSERT INTO `progetto1`.`noleggia` (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `DataScadenza`) VALUES ('BNMSRI98G47J702', 'Pinocchio', 'Matteo Garrone', 1, 3, '2021-06-15');
INSERT INTO `progetto1`.`noleggia` (`Cliente`, `FilmTitolo`, `FilmRegista`, `SettoreCodice`, `SettoreCentro`, `DataScadenza`) VALUES ('BNMSRI98G47J702', 'Harry Potter e la pietra filosofale', 'Chris Columbus', 3, 1, '2021-06-21');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`turno di lavoro`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-04-01', 'SMI89DMRD007', '2021-05-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-05-01', 'SMI89DMRD007', '2021-06-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'SMI89DMRD007', NULL);
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-04-01', 'CTF0483IMN42', '2021-05-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-05-01', 'CTF0483IMN42', '2021-06-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'CTF0483IMN42', NULL);
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'FRCMLN893IMN42', NULL);
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-04-01', 'GSPXXS986HJK52', '2021-05-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-05-01', 'GSPXXS986HJK52', '2021-06-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'GSPXXS986HJK52', NULL);
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-05-01', 'LGXFDR993HGN58', '2021-06-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'LGXFDR993HGN58', NULL);
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-05-01', 'FBXMLN89HDS78', '2021-06-01');
INSERT INTO `progetto1`.`turno di lavoro` (`DataInizio`, `Impiegato`, `DataFine`) VALUES ('2021-06-01', 'FBXMLN89HDS78', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`orariogiornaliero`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'SMI89DMRD007', '2021-04-01', '08:30', '10:30');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'SMI89DMRD007', '2021-05-01', '08:30', '10:30');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Wednesday', 'SMI89DMRD007', '2021-05-01', '15:00', '20:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'SMI89DMRD007', '2021-06-01', '08:30', '10:30');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Tuesday', 'SMI89DMRD007', '2021-06-01', '08:30', '15:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Wednesday', 'CTF0483IMN42', '2021-04-01', '08:30', '15:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Tuesday', 'CTF0483IMN42', '2021-04-01', '08:30', '16:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Thursday', 'CTF0483IMN42', '2021-05-01', '12:00', '20:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Friday', 'CTF0483IMN42', '2021-05-01', '10:00', '16:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Tuesday', 'CTF0483IMN42', '2021-06-01', '10:00', '16:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Thursday', 'CTF0483IMN42', '2021-06-01', '12:00', '18:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'FRCMLN893IMN42', '2021-06-01', '10:00', '17:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Friday', 'FRCMLN893IMN42', '2021-06-01', '12:00', '18:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'GSPXXS986HJK52', '2021-04-01', '10:00', '15:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Friday', 'GSPXXS986HJK52', '2021-04-01', '12:00', '16:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'GSPXXS986HJK52', '2021-05-01', '10:00', '18:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Thursday', 'GSPXXS986HJK52', '2021-06-01', '10:00', '17:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Wednesday', 'GSPXXS986HJK52', '2021-06-01', '08:30', '12:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'LGXFDR993HGN58', '2021-05-01', '08:30', '12:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Friday', 'LGXFDR993HGN58', '2021-05-01', '12:00', '16:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Wednesday', 'LGXFDR993HGN58', '2021-06-01', '10:00', '17:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Thursday', 'LGXFDR993HGN58', '2021-06-01', '08:30', '12:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'FBXMLN89HDS78', '2021-05-01', '08:30', '17:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Monday', 'FBXMLN89HDS78', '2021-06-01', '12:00', '17:00');
INSERT INTO `progetto1`.`orariogiornaliero` (`Giorno`, `TurnoDiLavoroI`, `TurnoDiLavoroData`, `OraInizio`, `OraFine`) VALUES ('Friday', 'FBXMLN89HDS78', '2021-06-01', '17:00', '20:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`telefonocentro`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`telefonocentro` (`Centro`, `Numero`) VALUES (1, '3920569863');
INSERT INTO `progetto1`.`telefonocentro` (`Centro`, `Numero`) VALUES (2, '3272838525');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`telefonocliente`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`telefonocliente` (`Cliente`, `Numero`) VALUES ('CCCMTT99H15I676', '3242890543');
INSERT INTO `progetto1`.`telefonocliente` (`Cliente`, `Numero`) VALUES ('CCCMTT99H15I676', '3672910543');
INSERT INTO `progetto1`.`telefonocliente` (`Cliente`, `Numero`) VALUES ('CCCMCC72H5I676', '3334445555');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`emailcliente`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`emailcliente` (`Cliente`, `Email`) VALUES ('CCCMTT99H15I676', 'matteo@gmail.com');
INSERT INTO `progetto1`.`emailcliente` (`Cliente`, `Email`) VALUES ('BNMSRI98G47J702', 'siria@outlook.it');
INSERT INTO `progetto1`.`emailcliente` (`Cliente`, `Email`) VALUES ('CCCMTT99H15I676', 'matteo@outlook.it');
INSERT INTO `progetto1`.`emailcliente` (`Cliente`, `Email`) VALUES ('CCCMCC72H5I676', 'marcello@gmail.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`reportOre`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-04-01', 'CTF0483IMN42', 50, '2021-05-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-05-01', 'CTF0483IMN42', 100, '2021-06-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'CTF0483IMN42', 30, NULL);
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-04-01', 'SMI89DMRD007', 60, '2021-05-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-05-01', 'SMI89DMRD007', 100, '2021-06-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'SMI89DMRD007', 30, NULL);
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'FRCMLN893IMN42', 25, NULL);
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-04-01', 'GSPXXS986HJK52', 40, '2021-05-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-05-01', 'GSPXXS986HJK52', 60, '2021-06-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'GSPXXS986HJK52', 30, NULL);
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-05-01', 'LGXFDR993HGN58', 45, '2021-06-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'LGXFDR993HGN58', 10, NULL);
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-05-01', 'FBXMLN89HDS78', 200, '2021-06-01');
INSERT INTO `progetto1`.`reportOre` (`DataInizio`, `Impiegato`, `Ore`, `DataFine`) VALUES ('2021-06-01', 'FBXMLN89HDS78', 30, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `progetto1`.`indirizzo cliente`
-- -----------------------------------------------------
START TRANSACTION;
USE `progetto1`;
INSERT INTO `progetto1`.`indirizzo cliente` (`Cliente`, `Indirizzo`) VALUES ('CCCMTT99H15I676', 'Via a caso');
INSERT INTO `progetto1`.`indirizzo cliente` (`Cliente`, `Indirizzo`) VALUES ('BNMSRI98G47J702', 'Via tizio caio sempronio');
INSERT INTO `progetto1`.`indirizzo cliente` (`Cliente`, `Indirizzo`) VALUES ('CCCMCC72H5I676', 'Via verdi');
INSERT INTO `progetto1`.`indirizzo cliente` (`Cliente`, `Indirizzo`) VALUES ('CCCMTT99H15I676', 'Via betulla');
INSERT INTO `progetto1`.`indirizzo cliente` (`Cliente`, `Indirizzo`) VALUES ('CCCMCC72H5I676', 'Via rossi');

COMMIT;


SET GLOBAL event_scheduler=ON;
delimiter |
CREATE EVENT `progetto1`.`ResettaGiorni`
ON SCHEDULE EVERY 24 DAY_HOUR

DO BEGIN
declare done int default false;
declare var_Date date;
declare var_Impiegato varchar(45);
declare var_Inizio time;
declare var_Fine time;
declare cur cursor for 
select `Impiegato` from `turno di lavoro` where `DataFine` is null;
declare continue handler for not found set done = true;
set transaction isolation level serializable;
start transaction;
if object_id('timbratura') is not null
then
open cur;
read_loop: loop
	fetch cur into var_Impiegato;
    if done 
        then leave read_loop;
	end if;
    select timeFine,timeInizio from `timbratura` where Impiegato=var_Impiegato into var_Fine,var_Inizio;
    if (var_Fine is not null and var_Inizio is not null)
    then
		update `reportOre`
		set Ore=Ore + HOUR(TIMEDIFF(var_Fine,var_Inizio))+ MINUTE(TIMEDIFF(var_Fine,var_Inizio))/100
		where Impiegato=var_Impiegato and `reportOre`.`DataFine` is null;
        select DataInizio
        from `reportOre`
        where Impiegato=var_Impiegato and `reportOre`.`DataFine` is null into var_Date;
        if (MONTH(var_Date)<MONTH(curdate()))
        then
			update `reportOre`
            set DataFine=curdate()
            where Impiegato=var_Impiegato and `reportOre`.`DataFine` is null;
            insert into `reportOre` (Impiegato,DataInizio,DataFine,Ore) values (var_Impiegato,curdate(),NULL,0);
		end if;
	end if;
    end loop;
    close cur;
	drop table `timbratura`;
end if;
END

