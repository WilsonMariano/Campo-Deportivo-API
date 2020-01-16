<?php

require_once "AccesoDatos.php";

class Bonos {

  public $id;
  public $idSocio;
  public $monto;
  public $fechaEmision;
  public $fechaAsignacion;
  public $horaAsignacion;
  public $codPrestacion;
  public $detalle;
  public $codEstadoBono;

  //Constructor customizado
  public function __construct($arrData = null) {
    if($arrData != null){
      $this->id = $arrData["id"] ?? null;
      $this->idSocio = $arrData["idSocio"];
      $this->monto = $arrData["monto"];
      $this->fechaEmision = $arrData["fechaEmision"];
      $this->fechaAsignacion = $arrData["fechaAsignacion"];
      $this->horaAsignacion = $arrData["horaAsignacion"] ?? null;
      $this->codPrestacion = $arrData["codPrestacion"];
      $this->detalle = $arrData["detalle"] ?? null;
      $this->codEstadoBono = $arrData["codEstadoBono"] ?? "cod_estado_bono_1";
    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':idSocio',            $objEntidad->idSocio,           \PDO::PARAM_INT);
    $consulta->bindValue(':monto',              $objEntidad->monto,             \PDO::PARAM_STR);
    $consulta->bindValue(':fechaEmision',       $objEntidad->fechaEmision,      \PDO::PARAM_STR);
    $consulta->bindValue(':fechaAsignacion',    $objEntidad->fechaAsignacion,   \PDO::PARAM_STR);
    $consulta->bindValue(':horaAsignacion',     $objEntidad->horaAsignacion,    \PDO::PARAM_STR);
    $consulta->bindValue(':codPrestacion',      $objEntidad->codPrestacion,     \PDO::PARAM_STR);
    $consulta->bindValue(':detalle',            $objEntidad->detalle,           \PDO::PARAM_STR);
    $consulta->bindValue(':codEstadoBono',      $objEntidad->codEstadoBono,     \PDO::PARAM_STR);
      
    if($includePK == true)
      $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
  }

  public static function GetBetweenDate($fechaDesde, $fechaHasta) {	
		 
    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
    $consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT * from vwbonos
    WHERE fechaEmision BETWEEN :fechaDesde AND :fechaHasta
    ");
    $consulta->bindValue(':fechaDesde',   $fechaDesde,   PDO::PARAM_STR);
    $consulta->bindValue(':fechaHasta',   $fechaHasta,   PDO::PARAM_STR);
    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }
  
}