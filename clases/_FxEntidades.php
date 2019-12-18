<?php

foreach (glob("clases/*.php") as $filename)
    require_once $filename;

class FxEntidades {

	public static function GetObjEntidad($entityName, $apiParamsBody = null){
		return new $entityName($apiParamsBody);
	}

    public static function GetAll($entityName) {

		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta('select * from ' .$entityName);
		$consulta->execute();		
		$arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
		
		return $arrObjEntidad;
	}

	public static function GetOne($idParametro,$entityName) {	

		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		
		$consulta =$objetoAccesoDato->RetornarConsulta("select * from " . $entityName . " where id =:id");
		$consulta->bindValue(':id', $idParametro, PDO::PARAM_INT);
		$consulta->execute();
		$objEntidad= $consulta->fetchObject($entityName);

		return $objEntidad;						
	}	 

	public static function InsertOne($objEntidad, $includePK = false) {

		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
					 
		//Obtengo el nombre de la clase y sus atributos
		$entityName = get_class($objEntidad);
		$arrAtributos = get_class_vars($entityName);

		//Armo la query SQL dinamicamente
		$myQuery = "insert into " . $entityName ." (" ;
		$myQueryAux = "";
		foreach ($arrAtributos as $atributo => $valor) {
			if ($atributo != "id" || $includePK){
				$myQuery .= $atributo .  ",";
				$myQueryAux .= ":".$atributo.","; 
			}
		}
		$myQuery = rtrim($myQuery,",") . ") values (" . rtrim($myQueryAux,",") . ")" ;

		//Ejecuto la query
		$consulta =$objetoAccesoDato->RetornarConsulta($myQuery);
		$objEntidad->BindQueryParams($consulta, $objEntidad, $includePK);
		$consulta->execute();
		
		return $consulta->rowCount() > 0 ? true : false;
	}

	public static function UpdateOne($objEntidad){
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
	
		//Obtengo el nombre de la clase y sus atributos
		$entityName = get_class($objEntidad);
		$arrAtributos = get_class_vars($entityName);

		//Armo la query SQL dinamicamente
		$myQuery = "update " . $entityName . " set ";
		foreach ($arrAtributos as $atributo => $valor) {
			if ($atributo != "id")
				$myQuery .= $atributo . "=:" . $atributo . ",";
		}
		$myQuery = rtrim($myQuery,",")." where  id=:id ";

		//Ejecuto la query
		$consulta =$objetoAccesoDato->RetornarConsulta($myQuery);
		$objEntidad->BindQueryParams($consulta,$objEntidad);
		$consulta->execute();
		
		return $consulta->rowCount() > 0 ? true : false;
	}

}