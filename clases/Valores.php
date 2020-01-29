<?php

require_once "AccesoDatos.php";

class Valores {

  public $id;
  public $codSocio;
  public $codPrestacion;
  public $codRangoEdad;
  public $codDia;
  public $valor;

  //Constructor customizado
  public function __construct($arrData = null) {

    if($arrData != null){
      $this->id = $arrData["id"] ?? null;
      $this->codSocial = $arrData["codSocial"];
      $this->codPrestacion = $arrData["codPrestacion"];
      $this->codRangoEdad = $arrData["codRangoEdad"];
      $this->codDia = $arrData["codDia"];
      $this->valor = $arrData["valor"];
    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':codSocio',            $objEntidad->codSocio,           \PDO::PARAM_STR);
    $consulta->bindValue(':codPrestacion',       $objEntidad->codPrestacion,      \PDO::PARAM_STR);
    $consulta->bindValue(':codRangoEdad',        $objEntidad->codRangoEdad,       \PDO::PARAM_STR);
    $consulta->bindValue(':codDia',              $objEntidad->codDia,             \PDO::PARAM_STR);
    $consulta->bindValue(':valor',               $objEntidad->valor,              \PDO::PARAM_STR);
      
    if($includePK == true)
      $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
  }

  public function GetValor($codPrestacion, $codEdad, $codDia, $codTipoSocio, $codParentesco) {

    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
		SELECT * 
		FROM Valores 
		WHERE codPrestacion = :codPrestacion 
		AND codParentesco = :codParentesco 
		AND codDia = :codDia 
		AND codTipoSocio = :codTipoSocio 
		AND codEdad = :codEdad");
		$consulta->bindValue(':codPrestacion',  $codPrestacion, PDO::PARAM_STR);
		$consulta->bindValue(':codParentesco',  $codParentesco, PDO::PARAM_STR);
		$consulta->bindValue(':codDia',         $codDia, PDO::PARAM_STR);
		$consulta->bindValue(':codTipoSocio',   $codTipoSocio, PDO::PARAM_STR);
		$consulta->bindValue(':codEdad',        $codEdad, PDO::PARAM_STR);
    $consulta->execute();
    
    $obj = $consulta->fetchObject('Valores');
		return $obj;	

  }
  
}