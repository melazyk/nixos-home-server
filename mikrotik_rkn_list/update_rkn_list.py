#!/usr/bin/env python
import os
import requests
import librouteros

api = librouteros.connect(username=os.environ['MIKROTIK_USER'],password=os.environ['MIKROTIK_PASS'],host=os.environ['MIKROTIK_HOST'])

prefix='https://antifilter.download/list/'
#lists= [ 'subnet.lst', 'ipsum.lst', 'ip.lst']
lists= [ 'subnet.lst', 'ipsum.lst' ]
target_list = os.environ['MIKROTIK_LIST']

nets = []
for lst in lists:
    r=requests.get(prefix+lst)
    if r.status_code != 200:
        continue
    for line in r.iter_lines():
        nets.append(line.decode('utf-8').strip())

mik_nets = {}
for line in api(cmd='/ip/firewall/address-list/print'):
    if line['list'] == target_list:
        mik_nets[line['address']] = line['.id']

for n in set(mik_nets)-set(nets):
    data={'.id': mik_nets[n]}
    api(cmd='/ip/firewall/address-list/remove',**data)


for n in set(nets)-set(mik_nets):
    data={'address': n, 'list': target_list}
    api(cmd='/ip/firewall/address-list/add',**data)

#code.interact(local=locals())
#print(data)
