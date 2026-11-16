rule set_kernel:
    input:
        f"{workflow.basedir}/envs/alignr-env.yaml",
    output:
        touch("results/.kernel.set"),
    conda:
        f"{workflow.basedir}/envs/alignr-env.yaml"
    log:
        "logs/set_kernel.log",

def alignr_outputs(wildcards):
    outputs = [ "results/alignr_done.txt" ]

    return outputs
#end def alignr_outputs
