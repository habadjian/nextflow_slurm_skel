#!/usr/bin/env nextflow

nextflow.enable.dsl=2

import groovy.yaml.YamlSlurper

def config = new YamlSlurper().parse(file('config.yaml'))

params.input_dir = config.input_dir ?: 'files'
params.output_dir = config.output_dir ?: 'output'

process PROCESS_FILES_1 {
    publishDir "${params.output_dir}"

    input:
    path txt_file

    output:
    path "processed_${txt_file}"

    script:
    """
    cat ${txt_file} > processed_${txt_file.baseName}.txt
    """
}

process PROCESS_FILES_2 {
    publishDir "${params.output_dir}"

    input:
    path txt_file

    output:
    path "processed_${txt_file}"

    script:
    """
    cat ${txt_file} > processed_${txt_file.baseName}.txt
    """
}

workflow {
    // Define a channel for text files
    txt_files_inner = Channel.fromPath("${params.input_dir}/**/*.txt")
    txt_files_outer =  Channel.fromPath("${params.input_dir}/*.txt")
    PROCESS_FILES_1(txt_files_outer)
    PROCESS_FILES_2(txt_files_inner)
}

