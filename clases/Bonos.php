<?php

require_once "AccesoDatos.php";

class Bonos {

  public $id;
  public $idSocio;
  public $monto;
  public $hash;
  public $fechaEmision;
  public $fechaAsignacion;
  public $codPrestacion;
  public $detalle;
  public $codEstadoBono;
  public $fechaUso;

  //Constructor customizado
  public function __construct($arrData = null) {
    if($arrData != null){
      $this->id = $arrData["id"] ?? null;
      $this->idSocio = $arrData["idSocio"];
      $this->monto = $arrData["monto"];
      $this->hash = $arrData["hash"];
      $this->fechaEmision = $arrData["fechaEmision"];
      $this->fechaAsignacion = $arrData["fechaAsignacion"];
      $this->codPrestacion = $arrData["codPrestacion"];
      $this->detalle = $arrData["detalle"];
      $this->codEstadoBono = $arrData["codEstadoBono"] ?? "cod_estado_bono_1";
      $this->fechaUso = $arrData["fechaUso"] ?? null;
    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':idSocio',            $objEntidad->idSocio,           \PDO::PARAM_INT);
    $consulta->bindValue(':monto',              $objEntidad->monto,             \PDO::PARAM_STR);
    $consulta->bindValue(':hash',               $objEntidad->hash,              \PDO::PARAM_STR);
    $consulta->bindValue(':fechaEmision',       $objEntidad->fechaEmision,      \PDO::PARAM_STR);
    $consulta->bindValue(':fechaAsignacion',    $objEntidad->fechaAsignacion,   \PDO::PARAM_STR);
    $consulta->bindValue(':codPrestacion',      $objEntidad->codPrestacion,     \PDO::PARAM_STR);
    $consulta->bindValue(':detalle',            $objEntidad->detalle,           \PDO::PARAM_STR);
    $consulta->bindValue(':fechaUso',           $objEntidad->fechaUso,          \PDO::PARAM_STR);
    $consulta->bindValue(':codEstadoBono',      $objEntidad->codEstadoBono,     \PDO::PARAM_STR);
      
    if($includePK == true)
      $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
  }
  
}