# Tape Archiver

a.k.a. `tar`.

```bash
# --xattrs preserves extended attributes, like
# access control lists and SELinux security context.
# -cvpf: create, verbose, permissions, filename
sudo tar --xattrs -cvpf etc.tar /etc
```

Compression algorithms using `tar`:

```bash
sudo tar --xattrs --gzip -cvpf etc.tar.gz /etc
sudo tar --xattrs --bzip2 -cvpf etc.tar.bz2 /etc
sudo tar --xattrs --xz -cvpf etc.tar.xz /etc
```

List what's compressed in the archive:

```bash
tar --gzip -tf etc.tar.gz
tar --bzip2 -tf etc.tar.bz2
tar --xz -tf etc.tar.xz
```

Extract all files from the archive:

```bash
sudo tar --xattrs -xvpf etc.tar
# Or specify an output directory
sudo tar --xattrs -xvpf etc.tar -C /home/vagrant/Downloads/
```

Compress `/etc/services` without `tar`:

```bash
# Copy it
cp /etc/services .

# Using gzip
gzip services
gunzip services.gz

# Using bzip2
bzip2 services
bunzip2 services.bz2

# Using xz
xz services
unxz services.xz

# Using zip (Windows-compatible)
zip services.zip services
unzip services.zip
```
