#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.input_dir = 'files'

process PROCESS_FILES {
    publishDir 'output'

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
