<?php

/* sudo pear install Console_CommandLine */
require_once 'Console/CommandLine.php';

$program = array(
    'description' => 'Program Template',
    'version'     => '1.0.0',
);

{
    global $program;
    list ( $config, $option, $args ) = _parse_program_environment();
    list ( $program['config'],
           $program['option'],
           $program['args'  ] ) = array( $config, $option, $args );
}


function _verbose( $str, $level = 1,  $nl = "\n" )
{
    global $program;
    if ( $program['option']['verbose'] >= $level ) {
        print "$str$nl";
    }
    flush();
}


function _warn( $str, $nl = "\n" )
{
    fputs( STDERR, "$str$nl" );
}


function _die( $str, $nl = "\n" )
{
    _warn( $str, $nl );
    exit( 255 );
}


function _usage()
{
    global $program;
    $program['parser']->displayUsage();
}


function _parse_program_environment()
{
    $option = _parse_program_option();
    $config = _parse_program_config( $option );
    $args   = _parse_program_args( $config, $config );

    return array( $config, $option, $args );
}


function _parse_program_config( $option )
{
//    $filename = $option['config'];
//    $config = yaml_parse_file( $filename );

//    return $config;
    return array();
}


function _parse_program_option()
{
    global $program;
    $parser = new Console_CommandLine( array(
        'description'        => $program['description'],
        'version'            => $program['version'],
        'add_help_option'    => TRUE,
        'add_version_option' => TRUE,
    ) );
    $parser->addOption( 'config', array(
        'short_name'  => '-c',
        'long_name'   => '--config',
        'action'      => 'StoreString',
        'help_name'   => 'yaml format',
        'description' => 'config file',
    ) );
    $parser->addOption( 'verbose', array(
        'short_name'  => '-v',
        'long_name'   => '--verbose',
        'action'      => 'Counter',
        'help_name'   => 'print message verbosely',
        'description' => 'print message verbosely',
    ) );

    try {
        $result = $parser->parse();
        $program['parser'] = $parser;
        $options = $program['option'] = $result->options;
        _verbose( "[ parsing program options ] ...", 2 );
        _verbose( var_export( $program['option'], TRUE ), 2 );
    } catch ( Exception $e ) {
        $parser->displayError( $e->getMessage() );
    }

    // check required options etc...

    return $options;
}


function _parse_program_args( $config, $option )
{
    _verbose( "[ parsing program args ] ...", 2 );

    global $program;
    $args = $program['parser']->args;
    _verbose( var_export( $args, TRUE ), 2 );

    // check required args etc...

    return $args;
}

