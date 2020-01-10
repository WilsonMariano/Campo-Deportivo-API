<?php

require_once "AccesoDatos.php";

class Ingresos {

    public $id;
    public $idSocio;
    public $fecha;
    public $hora;

    //Constructor customizado
  public function __construct($arrData = null) {

    if($arrData != null){
      $this->id =       $arrData["id"] ?? null;
      $this->idSocio =  $arrData["idSocio"];
      $this->fecha =    $arrData["fecha"];
      $this->hora =     $arrData["hora"];
    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':idSocio',             $objEntidad->idSocio,            \PDO::PARAM_INT);
    $consulta->bindValue(':fecha',               $objEntidad->fecha,              \PDO::PARAM_STR);
    $consulta->bindValue(':hora',                $objEntidad->hora,               \PDO::PARAM_STR);
      
    if($includePK == true)
      $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
  }

}