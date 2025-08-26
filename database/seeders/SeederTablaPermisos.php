<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

//agregamos el modelo de permisos de spatie
use Spatie\Permission\Models\Permission;

class SeederTablaPermisos extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $permisos = [
            /* DESCOMENTAR AL EJECUTAR EL SEEDER LA PRIMERA VEZ (SI NO HAY REGISTROS EN LA BASE DE DTAOS) */
            //Operaciones sobre tabla Usuarios
            'ver-usuario',
            'crear-usuario',
            'editar-usuario',
            'borrar-usuario',
            
            //Operaciones sobre tabla roles
            'ver-rol',
            'crear-rol',
            'editar-rol',
            'borrar-rol',

            //Operaciones sobre tabla Comunas
            'ver-comuna',
            'crear-comuna',
            'editar-comuna',
            'borrar-comuna',

            //Operaciones sobre tabla Comunidades
            'ver-comunidad',
            'crear-comunidad',
            'editar-comunidad',
            'borrar-comunidad', 

            //Operaciones sobre tabla Consejo_comunals
            'ver-consejocomunal',
            'crear-consejocomunal',
            'editar-consejocomunal',
            'borrar-consejocomunal', 

            //Operaciones sobre tabla Voceros
            'ver-vocero',
            'crear-vocero',
            'editar-vocero',
            'borrar-vocero',

            //Operaciones sobre tabla Ayudas
            'ver-ayuda',
            'crear-ayuda',
            'editar-ayuda',
            'borrar-ayuda',

            //Operaciones sobre tabla Proyectos
            'ver-proyecto',
            'crear-proyecto',
            'editar-proyecto',
            'borrar-proyecto',

            //  // Operaciones sobre tabla Ayudas
            //  'ver-ayuda_sociales',
            //  'crear-ayuda_sociales',
            //  'editar-ayuda_sociales',
            //  'borrar-ayuda_sociales',

            //  // Operaciones sobre tabla Viviendas
            //  'ver-vivienda',
            //  'crear-vivienda',
            //  'editar-vivienda',
            //  'borrar-vivienda',

            // Operaciones sobre tabla Evaluaciones
             'ver-evaluacion',
             'crear-evaluacion',
             'editar-evaluacion',
             

             // Operaciones sobre tabla Asignaciones
             'ver-asignacion',
             'crear-asignacion',
             'editar-asignacion',
             
             // Operaciones sobre tabla Planificaciones
             'ver-planificacion',
             'crear-planificacion',
             'editar-planificacion',

              // Operaciones sobre tabla Seguimientos
              'ver-seguimiento',
              'crear-seguimiento',
              'editar-seguimiento',
             
              // Operaciones sobre tabla ControlSeguimientos
              'ver-controlseguimiento',
              'crear-controlseguimiento',
              'editar-controlseguimiento',
             
            
            
        ];

        foreach($permisos as $permiso) {
            Permission::create(['name'=>$permiso]);
        }
    }
}
