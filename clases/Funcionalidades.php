<?php

require_once "AccesoDatos.php";

class Funcionalidades {

    public $id;
    public $codTipoSocio;
    public $codFuncionalidad;
    public $habilitado;

    public static function GetCodPrestacion($codTipoSocio, $codParentesco) {

        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT f.codFuncionalidad AS 'clave', d.valor
        FROM funcionalidades AS f
        INNER JOIN Diccionario AS d
        ON f.codFuncionalidad = d.clave
        WHERE codTipoSocio = :codTipoSocio
        AND codParentesco = :codParentesco
        AND codFuncionalidad like 'cod_prestacion%'
        AND habilitado = 1
        ");

        $consulta->bindValue(':codTipoSocio',   $codTipoSocio,   PDO::PARAM_STR);
        $consulta->bindValue(':codParentesco',   $codParentesco,   PDO::PARAM_STR);
        $consulta->execute();
        $arrObjEntidad= $consulta->fetchAll(PDO::FETCH_ASSOC);	
            
        return $arrObjEntidad;
    }

    public static function GetFuncionalidad($codTipoSocio, $codFuncionalidad) {
        
        $objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
        $consulta =$objetoAccesoDato->RetornarConsulta("
        SELECT *
        FROM funcionalidades
        WHERE codFuncionalidad = :codFuncionalidad
        AND codTipoSocio = :codTipoSocio
        ");

        $consulta->bindValue(':codTipoSocio',   $codTipoSocio,   PDO::PARAM_STR);
        $consulta->bindValue(':codFuncionalidad',  $codFuncionalidad,   PDO::PARAM_STR);
        $consulta->execute();
        $obj = $consulta->fetchObject('Funcionalidades');	
            
        return $obj;
    }
}