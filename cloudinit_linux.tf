# ############################################
# Here we define path to the actual script we
# want to run when instance is created.
#
# script path:       scripts/init.cfg
# some name:         init-script
#
# ############################################

data "template_file" "init-script" {
  template = file("scripts/init.cfg")

}

# ############################################
#
# This section is responsible for actual script
# usage in action.
#
# ############################################

data "template_cloudinit_config" "cloudinit-linux-jump_server" {

  gzip = false
  base64_encode = false

  # ##########################################
  # this is so called 'cloud config' kind of
  # script with specific syntax.
  #
  #   filename:       init.cfg
  #   content_type:   "text/cloud-config"
  #   content:        is specified as reference
  #                   link to above defined
  #                   script
  # ##########################################

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

}
