## hisat2:v2.0.5-1-deb_cv1

req1 <- list(class = "DockerRequirement",
             dockerPull = "biocontainers/hisat2:v2.0.5-1-deb_cv1")
req2 <- list(class = "InlineJavascriptRequirement")

p1 <- InputParam(id = "threadN", type = "int", prefix = "-p")
p2 <- InputParam(id = "IndexPrefix", type = "File", prefix = "-x", 
                  valueFrom = "$(self.dirname + '/' + self.basename)",
                  secondaryFiles = c("$(self.basename + '.1.ht2')", 
                                     "$(self.basename + '.2.ht2')",
                                     "$(self.basename + '.3.ht2')",
                                     "$(self.basename + '.4.ht2')",
                                     "$(self.basename + '.5.ht2')",
                                     "$(self.basename + '.6.ht2')",
                                     "$(self.basename + '.7.ht2')",
                                     "$(self.basename + '.8.ht2')"))
p3 <- InputParam(id = "fq1", type = "File", prefix = "-1")
p4 <- InputParam(id = "fq2", type = "File", prefix = "-2")
o1 <- OutputParam(id = "sam", type = "File", glob = "*.sam")

hisat2_align <- cwlProcess(baseCommand = "hisat2",
                         requirements = list(req1, req2),
                         inputs = InputParamList(p1, p2, p3, p4),
                         outputs = OutputParamList(o1),
                         stdout = "output.sam")


hisat2_align <- addMeta(
    hisat2_align,
    label = "hisat2_align",
    doc = "HISAT2 is a fast and sensitive alignment program for mapping next-generation sequencing reads (both DNA and RNA) to a population of human genomes as well as to a single reference genome.",
    inputLabels = c("threadN","IndexPrefix","fq1","fq2"),
    inputDocs = c("number of alignment threads to launch (1)","Index filename prefix (minus trailing .X.ht2).","fasrq file 1","fasrq file 2"),
    outputLabels = c("sam"),
    outputDocs = c("Aligned sam file"),
    extensions = list(
        author = "rworkflow team",
        date = "09-08-24",
        url = "https://github.com/DaehwanKimLab/hisat2",
        example = paste()
    )
)
