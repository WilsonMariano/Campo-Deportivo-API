<?php

require_once "AccesoDatos.php";
require_once "SociosTitulares.php";

class Socios extends SociosTitulares {

  public $id;
  public $idSocioTitular;
  public $nombre;
  public $apellido;
  public $dni;
  public $fechaNacimiento;
  public $codParentesco;
  public $activo;
  public $hash;

  //Constructor customizado
  public function __construct($arrData = null) {

    if($arrData != null) {

      $this->id = $arrData["id"] ?? null;
      $this->idSocioTitular = $arrData["idSocioTitular"] ?? null;
      $this->activo = $arrData["activo"];
      $this->nombre = $arrData["nombre"];
      $this->apellido = $arrData["apellido"];
      $this->dni = $arrData["dni"];
      $this->fechaNacimiento = $arrData["fechaNacimiento"];
      $this->codParentesco = $arrData["codParentesco"];
      $this->hash = $arrData["hash"] ?? null;
      $this->codTipoSocio = $arrData["codTipoSocio"]  ?? null;
      $this->nroAfiliado = $arrData["nroAfiliado"] ?? null;
      $this->fechaIngreso = $arrData["fechaIngreso"] ?? null;

    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':idSocioTitular',     $objEntidad->idSocioTitular,    PDO::PARAM_INT);
    $consulta->bindValue(':nombre',             $objEntidad->nombre,            PDO::PARAM_STR);
    $consulta->bindValue(':apellido',           $objEntidad->apellido,          PDO::PARAM_STR);
    $consulta->bindValue(':dni',                $objEntidad->dni,               PDO::PARAM_INT);
    $consulta->bindValue(':fechaNacimiento',    $objEntidad->fechaNacimiento,   PDO::PARAM_STR);
    $consulta->bindValue(':codParentesco',      $objEntidad->codParentesco,     PDO::PARAM_STR);
    $consulta->bindValue(':codTipoSocio',       $objEntidad->codTipoSocio,      PDO::PARAM_STR);
    $consulta->bindValue(':activo',             $objEntidad->activo,            PDO::PARAM_STR);
    $consulta->bindValue(':hash',               $objEntidad->hash,              PDO::PARAM_STR);
    $consulta->bindValue(':nroAfiliado',        $objEntidad->nroAfiliado,       PDO::PARAM_INT);
    $consulta->bindValue(':fechaIngreso',       $objEntidad->fechaIngreso,      PDO::PARAM_STR);

    if($includePK == true)
      $consulta->bindValue(':id'      , $objEntidad->id       ,\PDO::PARAM_INT);
  }
  
  public static function Insertar($socio) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    CALL insertSocio(
      :codTipoSocio, 
      :nroAfiliado,
      :fechaIngreso,
      :nombre,
      :apellido,
      :dni,
      :fechaNacimiento,
      :codParentesco,
      :activo,
      :hash)");
		$consulta->bindValue(':codTipoSocio',     $socio->codTipoSocio,     PDO::PARAM_STR);
		$consulta->bindValue(':nroAfiliado',      $socio->nroAfiliado,      PDO::PARAM_INT);
		$consulta->bindValue(':nombre',           $socio->nombre,           PDO::PARAM_STR);
		$consulta->bindValue(':apellido',         $socio->apellido,         PDO::PARAM_STR);
		$consulta->bindValue(':dni',              $socio->dni,              PDO::PARAM_INT);
		$consulta->bindValue(':fechaNacimiento',  $socio->fechaNacimiento,  PDO::PARAM_STR);
		$consulta->bindValue(':codParentesco',    $socio->codParentesco,    PDO::PARAM_STR);
		$consulta->bindValue(':activo',           $socio->activo,           PDO::PARAM_INT);
		$consulta->bindValue(':hash',             $socio->hash,             PDO::PARAM_STR);
		$consulta->bindValue(':fechaIngreso',     $socio->fechaIngreso,     PDO::PARAM_STR);
		$consulta->execute();
		
    return $consulta->rowCount();	
  }

  public static function InsertarFamilia($socio) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    INSERT INTO Socios(idSocioTitular, nombre, apellido, dni, fechaNacimiento, codParentesco, hash)
    VALUES (:idSocioTitular, :nombre, :apellido, :dni, :fechaNacimiento, :codParentesco, :hash)");

		$consulta->bindValue(':idSocioTitular',   $socio->idSocioTitular,   PDO::PARAM_INT);
		$consulta->bindValue(':nombre',           $socio->nombre,           PDO::PARAM_STR);
		$consulta->bindValue(':apellido',         $socio->apellido,         PDO::PARAM_STR);
		$consulta->bindValue(':dni',              $socio->dni,              PDO::PARAM_INT);
		$consulta->bindValue(':fechaNacimiento',  $socio->fechaNacimiento,  PDO::PARAM_STR);
		$consulta->bindValue(':codParentesco',    $socio->codParentesco,    PDO::PARAM_STR);
		$consulta->bindValue(':hash',             $socio->hash,             PDO::PARAM_STR);
		$consulta->execute();
		
    return $consulta->rowCount();	
  }
  
  public static function Update($socio) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    CALL updateSocio(
      :id,
      :idSocioTitular,
      :codTipoSocio, 
      :nroAfiliado,
      :nombre,
      :apellido,
      :dni,
      :fechaNacimiento,
      :codParentesco,
      :activo)");
		$consulta->bindValue(':id',               $socio->id,               PDO::PARAM_INT);
		$consulta->bindValue(':idSocioTitular',   $socio->idSocioTitular,   PDO::PARAM_INT);
		$consulta->bindValue(':codTipoSocio',     $socio->codTipoSocio,     PDO::PARAM_STR);
		$consulta->bindValue(':nroAfiliado',      $socio->nroAfiliado,      PDO::PARAM_INT);
		$consulta->bindValue(':nombre',           $socio->nombre,           PDO::PARAM_STR);
		$consulta->bindValue(':apellido',         $socio->apellido,         PDO::PARAM_STR);
		$consulta->bindValue(':dni',              $socio->dni,              PDO::PARAM_INT);
		$consulta->bindValue(':fechaNacimiento',  $socio->fechaNacimiento,  PDO::PARAM_STR);
		$consulta->bindValue(':codParentesco',    $socio->codParentesco,    PDO::PARAM_STR);
		$consulta->bindValue(':activo',           $socio->activo,           PDO::PARAM_INT);
		$consulta->execute();
		
    return $consulta->rowCount();	
  }

  public static function GetGroupFamily($idSocioTitular, $codParentesco) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT * 
    FROM vwSocios  
    WHERE idSocioTitular = :idSocioTitular
    AND codParentesco = :codParentesco
    ");
		$consulta->bindValue(':idSocioTitular',   $idSocioTitular,   PDO::PARAM_INT);
		$consulta->bindValue(':codParentesco',    $codParentesco,    PDO::PARAM_STR);
		$consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
		
		return $arrObjEntidad;
  }

  public static function Getone($idSocio) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT s.id, s.idSocioTitular, s.nombre, s.apellido, s.dni, s.fechaNacimiento, s.codParentesco, s.activo, s.hash, st.codTipoSocio, st.nroAfiliado, st.fechaIngreso 
    FROM Socios as s
    INNER JOIN SociosTitulares as st
    ON s.idSocioTitular = st.id  
    WHERE s.id = :idSocio
    ");
		$consulta->bindValue(':idSocio',   $idSocio,   PDO::PARAM_INT);
		$consulta->execute();
    $arrObjEntidad= $consulta->fetchObject('Socios');	
		
		return $arrObjEntidad;
  }

  public static function GetTitularByIdSocio($idSocio) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("CALL spGetSocioTitularByIdSocio(:idSocio)");
		$consulta->bindValue(':idSocio',   $idSocio,   PDO::PARAM_INT);
		$consulta->execute();
    $arrObjEntidad= $consulta->fetch(PDO::FETCH_ASSOC);	
		
		return $arrObjEntidad;
  }

  public static function GetIdByHash($hash) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT *
    FROM Socios  
    WHERE hash = :hash
    ");
		$consulta->bindValue(':hash',   $hash,   PDO::PARAM_INT);
		$consulta->execute();
    $obj= $consulta->fetch(PDO::FETCH_ASSOC);	
		
		return $obj;
  }

}