<?php

require_once "AccesoDatos.php";

class RangoEdad {

  public $id;
  public $codEdad;
  public $edadMin;
  public $edadMax;
  public $descripcion;

  //Constructor customizado
  public function __construct($arrData = null) {
    if($arrData != null){
      $this->id = $arrData["id"] ?? null;
      $this->codEdad = $arrData["codEdad"];
      $this->edadMin = $arrData["edadMin"];
      $this->edadMax = $arrData["edadMax"];
      $this->descripcion = $arrData["descripcion"];
    }
  }

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
    $consulta->bindValue(':codEdad',            $objEntidad->codEdad,           \PDO::PARAM_STR);
    $consulta->bindValue(':edadMin',            $objEntidad->edadMin,           \PDO::PARAM_INT);
    $consulta->bindValue(':edadMax',            $objEntidad->edadMax,           \PDO::PARAM_INT);
    $consulta->bindValue(':descripcion',        $objEntidad->descripcion,       \PDO::PARAM_STR);
      
      if($includePK == true)
    $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
	}
}