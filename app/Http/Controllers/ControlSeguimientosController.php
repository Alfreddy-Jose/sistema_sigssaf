<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ControlSeguimientos;
use App\Models\Seguimientos;
use Illuminate\Database\QueryException;
use App\Http\Controllers\BitacoraController;


class ControlSeguimientosController extends Controller
{
    function __construct()
    {
        $this->middleware('permission:ver-controlseguimiento|crear-controlseguimiento', ['only' => ['index']]);
        $this->middleware('permission:crear-controlseguimiento', ['only' => ['create', 'store']]);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $seguimientos = Seguimientos::all();
        return view('controlseguimiento.index', compact('seguimientos'));
    }

    // public function getPlanificacionDetalles($id)
    // {
    //     // Recupera el Planificacion por su ID
    //     $seguimiento = Seguimientos::find($id);

    //     if (!$seguimiento) {
    //         // Maneja el caso en que no se encuentre la persona
    //         return response()->json(['error' => 'Persona no encontrada'], 404);
    //     }

    //     // Devuelve los datos relevantes en formato JSON
    //     return response()->json([
    //         'impacto_ambiental' => $planificacion->impacto_ambiental,
    //         'impacto_social' => $planificacion->impacto_social,
            
    //         // 'documentos' => $proyecto->documentos,
    //     ]);
 
    // }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        
    }
}
