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
  
  public function getWithKeys($key) {

    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT * 
    FROM diccionario  
    WHERE clave like '%' :key '%'
    ");
		$consulta->bindValue(':key',   $key,   PDO::PARAM_STR);
    $consulta->execute();
    
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
		
		return $arrObjEntidad;
  }
}