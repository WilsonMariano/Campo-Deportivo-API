<?php

require_once __DIR__ . '/../_FxEntidades.php';
require_once __DIR__ . '/../_FXGlobales.php';

class BonosApi {

    public static function Insert($request, $response) {

        $apiParams = $request->getParsedBody();	

        $obj = new Bonos($apiParams);


        if($obj->codPrestacion != 'cod_prestacion_3') {

            // Valido que haya disponibilidad de horario
            if($obj->codPrestacion == 'cod_prestacion_1') {

                $horaDesde = _FxGlobales::SubHours($obj->horaAsignacion, 1);
                $horaHasta = _FxGlobales::AddHours($obj->horaAsignacion, 1);
            }

            if($obj->codPrestacion == 'cod_prestacion_2') {

                $horaDesde = _FxGlobales::SubHours($obj->horaAsignacion, 4);
                $horaHasta = _FxGlobales::AddHours($obj->horaAsignacion, 4);
            }



            $res = Bonos::GetAvailability($obj->fechaAsignacion, $horaDesde, $horaHasta, $obj->codPrestacion);



            if(sizeof($res) != 0)
                return $response->withJson([
                    'ok'    => false,
                    'msg'    => "Ya existe un bono asignado en ese rango horario"
                ], 200);
        
       
        }

        $res = FxEntidades::InsertOne($obj);

        if(is_numeric($res)) {

            $res2 = FxEntidades::GetOne($res, 'vwBonos');

            if($res2 != false) 
                return $response->withJson([
                    'ok'    => true,
                    'data'  => $res2
                ], 200);

            else
                return $response->withJson([
                    'ok'    => false,
                    'msg'    => "Error al recuperar el bono"
                ], 500);

        } else {

            return $response->withJson([
                'ok'    => false,
                'msg'    => "Error al insertar el bono"
            ], 500);
        }
    }

    public static function GetBetweenDate($request, $response) {

        $params = $request->getQueryParams();

        $res = Bonos::GetBetweenDate($params['fechaDesde'], $params['fechaHasta']);

        if(sizeof($res) != 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);
        
        else
            return $response->withJson([
                'ok'    => false,
                'msg'  => "No se encontraron bonos"
            ], 400);
    }

    public static function GetByDateAndPrestacion($request, $response) {

        $params = $request->getQueryParams();

        $res = Bonos::GetByDateAndPrestacion($params['fechaAsignacion'], $params['codPrestacion']);

        if(sizeof($res) != 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);
        
        else
            return $response->withJson([
                'ok'    => false,
                'msg'  => "No se encontraron bonos"
            ], 400);
    }

    public static function CancelBono($request, $response, $args)  {

        $res = Bonos::CancelBono($args['id']);

        if($res != 0)
            return $response->withJson([
                'ok'    => true,
                'msg'   => "Bono anulado con éxito"
            ], 200);

        else
            return $response->withJson([
                'ok'    => false,
                'msg'   => "El bono no pudo anularse"
            ], 400);
    }   
}