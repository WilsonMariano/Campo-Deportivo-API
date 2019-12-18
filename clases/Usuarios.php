<?php

require_once "AccesoDatos.php";

class Usuarios
{

	public $id;
	public $usuario;
	public $password;
	public $codRole;

	//Constructor customizado
	public function __construct($arrData = null){
		if($arrData != null){
			$this->id = $arrData["id"] ?? null;
			$this->usuario = $arrData["usuario"];
			$this->password = $arrData["password"];
			$this->codRole = $arrData["codRole"];
		}
    }

	public function BindQueryParams($consulta, $objEntidad, $includePK = true) {
		
		$consulta->bindValue(':usuario',            $objEntidad->usuario,           \PDO::PARAM_STR);
        $consulta->bindValue(':password',           $objEntidad->password,          \PDO::PARAM_STR);
        $consulta->bindValue(':codRole',           	$objEntidad->codRole,          	\PDO::PARAM_STR);
        
        if($includePK == true)
			$consulta->bindValue(':id',     $objEntidad->id,       \PDO::PARAM_INT);
	}


 	public static function TraerUno($usuario) {	
		 
		$objetoAccesoDato = AccesoDatos::dameUnObjetoAcceso(); 
		$consulta =$objetoAccesoDato->RetornarConsulta("
		SELECT * 
		FROM Usuarios 
		WHERE usuario = :usuario 
		AND password = :password");
		$consulta->bindValue(':usuario', $usuario->usuario, PDO::PARAM_STR);
		$consulta->bindValue(':password', $usuario->password, PDO::PARAM_STR);
		$consulta->execute();
		
		$usuarioBuscado= $consulta->fetchObject('usuarios');
		return $usuarioBuscado;						
	}

}