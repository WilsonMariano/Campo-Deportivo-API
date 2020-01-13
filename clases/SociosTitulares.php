<?php

require_once "AccesoDatos.php";

class SociosTitulares {

  // public $id;
  public $codTipoSocio;
  public $nroAfiliado;
  public $fechaIngreso;

      //Constructor customizado
  // public function __construct($arrData = null) {

  //   if($arrData != null){
  //     $this->id = $arrData["id"] ?? null;
  //     $this->codTipoSocio = $arrData["codTipoSocio"];
  //     $this->nroAfiliado = $arrData["nroAfiliado"];
  //   }
  // }

  // public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
  
  //   $consulta->bindValue(':codTipoSocio',   $objEntidad->codTipoSocio,    \PDO::PARAM_STR);
  //   $consulta->bindValue(':nroAfiliado',    $objEntidad->nroAfiliado,     \PDO::PARAM_INT);
        
  //   if($includePK == true)
  //     $consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
  // }
  
}