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

      public static function GetBySocioTitular($idSocioTitular) {	
		 
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT *
        FROM vwCuotas
        WHERE idSocioTitular = :idSocioTitular
        ");
        $consulta->bindValue(':idSocioTitular',   $idSocioTitular,   PDO::PARAM_INT);
        $consulta->execute();
        $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
        
        return $arrObjEntidad;
      }
}