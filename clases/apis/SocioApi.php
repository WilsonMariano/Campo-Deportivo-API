<?php

require_once __DIR__ . '/../Socios.php';
require_once __DIR__ . '/../_FxEntidades.php';

class SocioApi {

    public static function Insert($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $res = Socios::Insertar($objEntidad);

        if($res == 2) {
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Socio insertado con éxito"
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error'
            ], 500);
    } 

    public static function InsertFamilia($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $res = Socios::InsertarFamilia($objEntidad);

        if($res == 1) {
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Socio insertado con éxito"
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error'
            ], 500);
    } 

    public static function Update($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $res = Socios::Update($objEntidad);

        if($res != 0) {
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Socio actualizado con éxito"
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error'
            ], 500);
    } 

    public static function GetGroupFamily($request, $response, $args) {

        $idSocioTitular = json_decode($args['idSocioTitular']);

        $res = Socios::GetGroupFamily($idSocioTitular);

        if(sizeof($res) > 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);

        else
        return $response->withJson([
            'ok'    => false,
            'msg'   => 'No existen socios con ese id'
        ], 400);
    
    }

    public static function GetOne($request, $response, $args) {

        $idSocio = json_decode($args['idSocio']);

        $res = Socios::GetOne($idSocio);

        // self::CalculateAge($res);
        // return;

        $res->edad = 20;

        if($res != false)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);

        else
        return $response->withJson([
            'ok'    => false,
            'msg'   => 'No existen socios con ese id'
        ], 400);
    
    }

    public static function CalculateAge($socio) {

        // $birthDate = $socio->fechaNacimiento;
        $birthDate = "03-01-2000";
        $arrBDate = explode("-", $birthDate);

        $age = (date("Y") - $arrBDate[0]);

        if($arrBDate[1] < date("M") || $arrBDate[1] == date("M") && $arrBDate[2] < date("dd") )
            $age--;
        
        var_dump($age);


    }

}