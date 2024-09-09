cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: MergeVcf_MMS.R
    entry: |-
      .libPaths(c('/projects/rpci/songliu/qhu/miniconda3/envs/r-base/lib/R/library'))
      suppressPackageStartupMessages(library(R.utils))
      args <- commandArgs(trailingOnly = TRUE, asValues = TRUE)
      MergeVcf_MMS <-
      function(vcf_mt, vcf_ms, vcf_ss, vcf_si, id_t, id_n, outvcf){
          library(VariantCombiner)
          ## merge mutect and muse
          v_m <- MergeSomatic(vcf_mt, vcf_ms, sources = c("mutect2", "MuSE"),
                              GENO = c(GT = 1, DP = 1, AD = 1),
                              id_t = id_t, id_n = id_n, pass_only = TRUE)
          ## merge strelka snv and indel
          v1 <- readVcf(vcf_ss)
          v2 <- readVcf(vcf_si)
          v1a <- strelka_snv(v1)
          v2a <- strelka_indel(v2)
          v_s <- MergeSomatic(v1a, v2a, sources = c("strelka2", "strelka2"),
                              GENO = c(GT = 1, DP = 1, AD = 1),
                              id_t = id_t, id_n = id_n, pass_only = TRUE)

          vm <- MergeSomatic(v_m, v_s, sources = c("", ""),
                             GENO = c(GT = 1, DP = 1, AD = 1),
                             id_t = id_t, id_n = id_n)
          writeVcf(vm, outvcf)
      }
      do.call(MergeVcf_MMS, args)
    writable: false
- class: DockerRequirement
  dockerPull: hubentu/variantcombiner
arguments:
- MergeVcf_MMS.R
inputs:
  mutect:
    type: File
    inputBinding:
      prefix: vcf_mt=
      separate: false
  muse:
    type: File
    inputBinding:
      prefix: vcf_ms=
      separate: false
  strelka_s:
    type: File
    inputBinding:
      prefix: vcf_ss=
      separate: false
  strelka_i:
    type: File
    inputBinding:
      prefix: vcf_si=
      separate: false
  id_t:
    type: string
    inputBinding:
      prefix: id_t=
      separate: false
  id_n:
    type: string
    inputBinding:
      prefix: id_n=
      separate: false
  outvcf:
    type: string
    inputBinding:
      prefix: outvcf=
      separate: false
outputs:
  ovcf:
    type: File
    outputBinding:
      glob: $(inputs.outvcf)
