<?php

require_once "AccesoDatos.php";

class Diccionario {

  public $id;
  public $clave;
  public $valor;

  public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
  $consulta->bindValue(':clave',            $objEntidad->clave,           \PDO::PARAM_STR);
  $consulta->bindValue(':valor',            $objEntidad->valor,           \PDO::PARAM_STR);
      
  if($includePK == true)
    $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
    
	}
}