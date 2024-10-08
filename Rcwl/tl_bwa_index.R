### bwa_index : only for long genome (-a bwtsw)

req1 <- list(class = "DockerRequirement",
             dockerPull = "biocontainers/bwa:v0.7.17-3-deb_cv1")
req2 <- list(class = "InitialWorkDirRequirement", 
             listing = list("$(inputs.Ref)"))
req3 <- list(class = "InlineJavascriptRequirement")

p1 <- InputParam(id = "Ref", type = "File", valueFrom = "$(self.basename)")
o1 <- OutputParam(id = "idx", type = "File", 
                  glob = "$(inputs.Ref.basename)",
                  secondaryFiles = c("$(inputs.Ref.basename + '.amb')",
                                     "$(inputs.Ref.basename + '.ann')", 
                                     "$(inputs.Ref.basename + '.bwt')",
                                     "$(inputs.Ref.basename + '.pac')",
                                     "$(inputs.Ref.basename + '.sa')") )

bwa_index <- cwlProcess(baseCommand = c("bwa", "index"), 
                      requirements = list(req1, req2, req3),
                      arguments = list("-a", "bwtsw"), 
                      inputs = InputParamList(p1), 
                      outputs = OutputParamList(o1))


bwa_index <- addMeta(
    bwa_index,
    label = "bwa_index",
    doc = "Index referenc file using BWA mem",
    inputLabels = c("Ref"),
    inputDocs = c("Reference fasta file"),
    outputLabels = c("idx"),
    outputDocs = c("Index reference file"),
    extensions = list(
        author = "rworkflow team",
        date = "09-08-24",
        url = "https://github.com/lh3/bwa",
        example = paste()
    )
)
