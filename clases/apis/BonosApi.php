<?php

require_once __DIR__ . '/../_FxEntidades.php';
require_once __DIR__ . '/../_FXGlobales.php';

class BonosApi {

    public static function Insert($request, $response) {

        $apiParams = $request->getParsedBody();	

        $obj = new Bonos($apiParams);


        // Si la prestacion no es Predio
        if($obj->codPrestacion != 'cod_prestacion_3') {

            $duracion = 0;
            $arrPrestaciones = array();

            // Si la prestacion es de tipo cancha, establezco la duracion en 1 hora
            if($obj->codPrestacion == 'cod_prestacion_1' || $obj->codPrestacion == 'cod_prestacion_4' || $obj->codPrestacion == 'cod_prestacion_5') {

                $duracion = 1;

                // Armo el array para buscar las prestaciones
                // Si se reserva la cancha 1 no puede estar reservada ni la 1, ni la 3
                // Si se reserva la cancha 2 no puede estar reservada ni la 2, ni la 3
                // Si se reserva la cancha 3 no puede estar reservada ni la 1, ni la 2, ni la 3
                if($obj->codPrestacion == 'cod_prestacion_1')
                    array_push($arrPrestaciones, 'cod_prestacion_1', 'cod_prestacion_5');

                if($obj->codPrestacion == 'cod_prestacion_4')
                    array_push($arrPrestaciones, 'cod_prestacion_4', 'cod_prestacion_5');
                
                if($obj->codPrestacion == 'cod_prestacion_5')
                    array_push($arrPrestaciones, 'cod_prestacion_1', 'cod_prestacion_4', 'cod_prestacion_5');
            }

            // Si la prestacion es de tipo quincho, establezco la duracion en 4 horas
            if($obj->codPrestacion == 'cod_prestacion_2') {

                $duracion = 4;
                array_push($arrPrestaciones, 'cod_prestacion_2');
                
            }

            // Calculo la cantidad de horas de margen
            $horaDesde = _FxGlobales::SubHours($obj->horaAsignacion, $duracion);
            $horaHasta = _FxGlobales::AddHours($obj->horaAsignacion, $duracion);

            $obj->horaFin = $horaHasta;


            // Esto devuelve un array de bonos dentro del periodo buscado
            $res = Bonos::GetAvailability($obj->fechaAsignacion, $horaDesde, $horaHasta, $arrPrestaciones);

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

    public static function GetForCalendar($request, $response) {

        $fecha = date('Y') .'-'. date('n') .'-'. date('j');

        $res = Bonos::GetForCalendar($fecha);

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
}