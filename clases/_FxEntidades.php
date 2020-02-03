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
		$objEntidad= $consulta->fetch(PDO::FETCH_ASSOC);
		// $objEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);

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
		
		// return $consulta->rowCount() > 0 ? true : false;
		return $objetoAccesoDato->RetornarUltimoIdInsertado();
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

	public static function GetPagedWithOptionalFilter($entityName, $column1, $text1, $stict, $column2, $text2, $rows, $page) {
		
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 

		$consulta =$objetoAccesoDato->RetornarConsulta(
			"call spGetPagedWithOptionalFilter('$entityName', '$column1', '$text1', $stict, '$column2', '$text2', $rows, $page, @o_total_rows)");

		$consulta->execute();
		$arrResult= $consulta->fetchAll(PDO::FETCH_ASSOC);	
		$consulta->closeCursor();
		
		$output = $objetoAccesoDato->Query("select @o_total_rows as total_rows")->fetchObject();
			
		//Armo la respuesta
		$result = new \stdClass();
		//Uso ceil() para redondear de manera ascendente
		$result->total_pages = ceil(intval($output->total_rows)/intval($rows));
		$result->total_rows = $output->total_rows;
		$result->data = $arrResult;
		
		return $result;					
	}

	public static function GetIngresosCaja($fechaDesde, $fechaHasta) {	
		 
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT * FROM 
		((SELECT fechaPago AS 'fecha', monto, descripcion, apellido, nombre, idSocio FROM vwcuotas) UNION 
		(SELECT fechaEmision AS 'fecha', monto, prestacion AS 'descripcion', apellido, nombre, idSocio FROM vwbonos)) AS i
		WHERE i.fecha BETWEEN :fechaDesde AND :fechaHasta
		ORDER BY i.fecha ASC
        ");
        $consulta->bindValue(':fechaDesde',   $fechaDesde,   PDO::PARAM_STR);
        $consulta->bindValue(':fechaHasta',   $fechaHasta,   PDO::PARAM_STR);
        $consulta->execute();
        $obj = $consulta->fetchAll(PDO::FETCH_ASSOC);	
        
        return $obj;
      }

}