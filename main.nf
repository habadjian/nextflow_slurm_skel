#!/usr/bin/env nextflow

nextflow.enable.dsl=2

import groovy.yaml.YamlSlurper

def config = new YamlSlurper().parse(file('config.yaml'))

params.input_dir = config.input_dir ?: 'files'
params.output_dir = config.output_dir ?: 'output'

process PROCESS_FILES {
    publishDir "${params.output_dir}"

    input:
    path txt_file

    output:
    path "processed_${txt_file}"

    script:
    """
    cat ${txt_file} > "processed_${txt_file}"
    """
}

workflow {
    Channel
        .fromPath("${params.input_dir}/*.txt")
        .set { files_ch }

    PROCESS_FILES(files_ch)
}

