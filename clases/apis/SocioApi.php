<?php

require_once __DIR__ . '/../Socios.php';
require_once __DIR__ . '/../Bonos.php';
require_once __DIR__ . '/../Cuotas.php';
require_once __DIR__ . '/../Ingresos.php';
require_once __DIR__ . '/../_FxEntidades.php';

class SocioApi {

    public static function Insert($request, $response, $args) {
        $apiParamsBody = $request->getParsedBody();

        // Obtengo instancia de clase correspondiente.
        $objEntidad = FxEntidades::GetObjEntidad('Socios', $apiParamsBody);

        $date = new DateTime();
        $objEntidad->hash = md5($date->getTimestamp() + $objEntidad->dni);
        $objEntidad->fechaIngreso = date('Y-m-d');
        

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

        // Creo y asigno el hash
        $date = new DateTime();
        $objEntidad->hash = md5($date->getTimestamp() + $objEntidad->dni);

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

        $res = Socios::GetGroupFamily($args['idSocioTitular'], $args['codParentesco']);

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

    
        // CALCULAR EDAD!!!
        $res['edad'] = 20;

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

    public static function GetTitularByIdSocio($request, $response, $args) {

        $idSocio = json_decode($args['idSocio']);

        $res = Socios::GetTitularByIdSocio($idSocio);

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

    public static function RegisterSocio($request, $response, $args) {

        $params = $request->getParsedBody();

        if($params['tipo'] == 'hash')
            $method = 'GetIdByHash';
        else
            $method = 'GetOne';

        // Recupero el socio 
        $socio = Socios::$method($params['valor']);

        // Si no existe el socio
        if(!$socio)
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Socio inexistente'
            ], 200);

        // Si el socio esta inactivo
        if($socio['activo'] == 0)
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Socio inactivo'
            ], 200);

        // Fecha hoy
        $fecha = date("Y-m-d");
        $hora = date("H:i");

        // Registro el ingreso
        $res = Ingresos::Insert($socio['id'], $fecha, $hora);

        // Si el ingreso falla
        if($res != 1)
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'Se produjo un error, intente mas tarde'
            ], 400);

        
        // Recupero el ultimo vencimiento del socio
        $venc = Cuotas::GetLastVencimiento($socio['idSocioTitular']);     
        
        // Recupero los bonos emitidos
        $bonos = Bonos::GetByDateAndIdSocio($fecha, $socio['id']);


        return $response->withJson([
            'ok'    => true,
            'data'  => array(
                'socio'       => $socio,  
                'vencimiento' => $venc['fechaVencimiento'],
                'bonos'       => $bonos
            )
        ]);      

    }

}