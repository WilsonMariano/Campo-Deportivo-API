<?php

require_once "AccesoDatos.php";

class Cuotas {

    public $id;
    public $idSocioTitular;
    public $fechaPago;
    public $fechaVencimiento;
    public $monto;
    public $descripcion;

    public function __construct($arrData = null) {

        if($arrData != null){
          $this->id =               $arrData["id"] ?? null;
          $this->idSocioTitular =   $arrData["idSocioTitular"];
          $this->fechaPago =        $arrData["fechaPago"];
          $this->fechaVencimiento = $arrData["fechaVencimiento"];
          $this->monto =            $arrData["monto"];
          $this->descripcion =      $arrData["descripcion"];
        }
      }
    
      public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
      
        $consulta->bindValue(':idSocioTitular',     $objEntidad->idSocioTitular,    \PDO::PARAM_INT);
        $consulta->bindValue(':fechaPago',          $objEntidad->fechaPago,         \PDO::PARAM_STR);
        $consulta->bindValue(':fechaVencimiento',   $objEntidad->fechaVencimiento,  \PDO::PARAM_STR);
        $consulta->bindValue(':monto',              $objEntidad->monto,             \PDO::PARAM_STR);
        $consulta->bindValue(':descripcion',        $objEntidad->descripcion,       \PDO::PARAM_STR);
          
        if($includePK == true)
          $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
      }

      public static function GetBySocio($idSocio) {	
		 
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT c.id, c.fechaPago, c.fechaVencimiento, c.monto, c.descripcion, c.apellido, c.nombre, c.idSocio, c.idSocioTitular  
        FROM vwCuotas AS c
        INNER JOIN socios AS s
        ON c.idSocioTitular = s.idSocioTitular
        WHERE s.id = :idSocio
        ");
        $consulta->bindValue(':idSocio',   $idSocio,   PDO::PARAM_INT);
        $consulta->execute();
        $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
        
        return $arrObjEntidad;
      }

      public static function GetLastVencimiento($idSocioTitular) {	
		 
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT fechaVencimiento
        FROM cuotas 
        WHERE idSocioTitular = :idSocioTitular
        ORDER BY fechaVencimiento DESC LIMIT 1
        ");
        $consulta->bindValue(':idSocioTitular',   $idSocioTitular,   PDO::PARAM_INT);
        $consulta->execute();
        $obj= $consulta->fetch(PDO::FETCH_ASSOC);	
        
        return $obj;
      }

      public static function GetBetweenDates($fechaDesde, $fechaHasta) {	
		 
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT *
        FROM vwCuotas 
        WHERE fechaPago between :fechaDesde AND :fechaHasta
        ORDER BY fechaPago ASC
        ");
        $consulta->bindValue(':fechaDesde',   $fechaDesde,   PDO::PARAM_STR);
        $consulta->bindValue(':fechaHasta',   $fechaHasta,   PDO::PARAM_STR);
        $consulta->execute();
        $obj = $consulta->fetchAll(PDO::FETCH_ASSOC);	
        
        return $obj;
      }
      
}