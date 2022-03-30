for x in $(terraform state list | grep module.name_to_search); do terraform taint $x; done
