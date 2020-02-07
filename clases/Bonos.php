<?php

require_once "AccesoDatos.php";

class Bonos {

  public $id;
  public $idSocio;
  public $monto;
  public $fechaEmision;
  public $fechaAsignacion;
  public $horaAsignacion;
  public $horaFin;
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
      $this->horaFin = $arrData["horaFin"] ?? null;
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
    $consulta->bindValue(':horaFin',            $objEntidad->horaFin,           \PDO::PARAM_STR);
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
    ORDER BY fechaEmision ASC
    ");
    $consulta->bindValue(':fechaDesde',   $fechaDesde,   PDO::PARAM_STR);
    $consulta->bindValue(':fechaHasta',   $fechaHasta,   PDO::PARAM_STR);
    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }

  public static function GetByDateAndPrestacion($fechaAsignacion, $codPrestacion) {	
		 
    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
    $consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT * from vwbonos
    WHERE fechaAsignacion = :fechaAsignacion
    AND codPrestacion = :codPrestacion
    AND codEstadoBono = 'cod_estado_bono_1'
    ORDER BY horaAsignacion ASC
    ");
    $consulta->bindValue(':fechaAsignacion',   $fechaAsignacion,   PDO::PARAM_STR);
    $consulta->bindValue(':codPrestacion',     $codPrestacion,     PDO::PARAM_STR);
    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }

  public static function GetByDateAndIdSocio($fechaDesde, $idSocio) {	
		 
    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
    $consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT * from vwbonos
    WHERE fechaAsignacion >= :fechaDesde 
    AND idSocio = :idSocio 
    AND codEstadoBono != 'cod_estado_bono_2'
    ");
    $consulta->bindValue(':fechaDesde',   $fechaDesde,    PDO::PARAM_STR);
    $consulta->bindValue(':idSocio',      $idSocio,       PDO::PARAM_INT);
    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }

  public static function GetAvailability($fechaAsignacion, $horaDesde, $horaHasta, $arrPrestaciones) {	
    
    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
    $query = "
    SELECT * 
    FROM bonos WHERE fechaAsignacion = ? 
    AND codEstadoBono = 'cod_estado_bono_1'
    AND horaAsignacion > ? AND horaAsignacion < ? AND";

    for($i = 0; $i < sizeof($arrPrestaciones); $i++) {

      if($i == 0)
        $query .= " (codPrestacion = ?";
      else
        $query .= " OR codPrestacion = ?";
    }

    $query .= ")";

    $consulta = $objetoAccesoDato->RetornarConsulta($query);

    $consulta->bindValue(1,          $fechaAsignacion,     PDO::PARAM_STR);
    $consulta->bindValue(2,          $horaDesde,           PDO::PARAM_STR);
    $consulta->bindValue(3,          $horaHasta,           PDO::PARAM_STR);

    for($i = 0; $i < sizeof($arrPrestaciones); $i++) {

      $consulta->bindValue($i + 4,   $arrPrestaciones[$i],          PDO::PARAM_STR);

    }

    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }

  public static function CancelBono($idBono) {

    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso();
    $consulta = $objetoAccesoDato->RetornarConsulta("
    UPDATE Bonos 
    SET codEstadoBono = 'cod_estado_bono_2'
    WHERE id = :idBono
    ");
    $consulta->bindValue(':idBono', $idBono, PDO::PARAM_INT);
    $consulta->execute();

    return $consulta->rowCount();
  }

  public static function GetForCalendar($fechaDesde) {	
		 
    $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
    $consulta =$objetoAccesoDato->RetornarConsulta("
    SELECT id, nombre, apellido, fechaAsignacion, horaAsignacion, horaFin, codPrestacion from vwbonos
    WHERE fechaAsignacion >= :fechaDesde
    AND codPrestacion != 'cod_prestacion_3' 
    AND codEstadoBono = 'cod_estado_bono_1'
    ORDER BY fechaAsignacion ASC
    ");
    $consulta->bindValue(':fechaDesde',   $fechaDesde,   PDO::PARAM_STR);
    $consulta->execute();
    $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
    
    return $arrObjEntidad;
  }
  
}