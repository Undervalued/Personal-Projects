import json, requests
import socket, asyncio
from tabulate import tabulate
# from websocket import WebSocket
import websockets
import tkinter as tk
from tkinter import *
from tkinter import ttk

default_exploits = {
    'casino_money': {
        'payload': '',
        'values': ['money']
    },
    'chat_spam':{
        'payload': '',
        'values': ['message']
    }
}


class Principal(tk.Tk):
    ventanas = None
    contextid = None
    websock_url = None
    counter = 0
    def __init__(self, master=''):
        super().__init__()
        # self.websock_url = 
        # self.master = master
        # self.frame = tk.Frame(self.master)
        self.title('epaa')
        # input()
        # self.button1 = tk.Button(self.frame, text = 'Connect', width = 25, command = self.connect)
        # self.button1.pack()
        self.button1 = ttk.Button(self,
                text='Connect',
                command=self.connect)#.pack(expand=True)
        self.button1.pack()
        # self.config(width=600, height=600)
        
        # self.tbox1 = Text(self)
        self.tbox1 = Text(self)
        
        
        # self.frame.pack()
    
    def connect(self):
        headers = {
            'Connection': 'keep-alive',
            'Cache-Control': 'max-age=0',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'Sec-GPC': '1',
            'Sec-Fetch-Site': 'none',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-User': '?1',
            'Sec-Fetch-Dest': 'document',
            'Accept-Language': 'es-ES,es;q=0.9',
        }
        response = requests.get('http://127.0.0.1:13172/json', headers=headers)
        for x in response.json():
            if x['url'] == 'nui://game/ui/root.html':
                self.websock_url = x['webSocketDebuggerUrl']
                self.button1.pack_forget()
                # self.config(width=600, height=600)
                self.geometry('600x600')
                # self.config
                self.tbox1.place(x=45, y=10, height=500, width=500)
                self.b = tk.Button(self, text = "Inject", width = 10, command = lambda: self.inject(self.tbox1.get("1.0",END)) )
                # self.b.place_configure(x=300, y=500)
                self.b.pack()
                self.b.place(x=260, y=520)
                # self.c = tk.Button(self, text = "Ventana", width = 10, command = self.open_casinoexploit)
                # self.c.pack()
                menubar = tk.Menu(self)
                filemenu = tk.Menu(menubar)
                filemenu.add_command(label="Casino Injection", command = self.open_casinoexploit)
                filemenu.add_command(label="Chat Exploit", command = self.open_casinoexploit)
                filemenu.add_command(label="Exit")
                menubar.add_cascade(label="Default Injections", menu=filemenu)
                self.config(menu=menubar)
                
                self.injec()
                print('Connected.')
    def new_window(self):
        print('epa')
    async def send(self, method, params):
        print('-'*25+ " Nuevo " + '-'*25)
        async with websockets.connect(self.websock_url, ping_interval=None) as ws:
            self.counter += 1
            # separators is important, you'll get "Message should be in JSON format." otherwise
            message = json.dumps({"id": self.counter, "method": method, "params": params}, separators=(',', ':'))
            print("> %s" % (message,))
            await ws.send(message)
            # print('-'*50)
            result = []
            while True:
                # print('a')
                try:
                    result1 = await ws.recv()
                    result.append(result1)
                    # print("< %s" % (result1,))
                    try:
                        x=json.loads(result1)['result']
                        break
                    except:
                        pass
                # print(dict(result)['result'])
                except Exception as e:
                    print(e)
            # print(result)
            if(len(result ) > 1):
                return result
            else:
                return result[0]

    async def conseguir_contexts(self, idd):
        frameid = self.ventanas['result']['frameTree']['childFrames'][int(idd)]['frame']['id']
        result = await self.send('Runtime.enable', {})
        for x in result:
            y=json.loads(x)
            try:
                if(frameid == y['params']['context']['auxData']['frameId']):
                    print(y['params']['context']['uniqueId'])
                    self.contextid = y['params']['context']['uniqueId']
            except:
                pass

    async def conseguir_ventanas(self):
        result = await self.send('Page.getResourceTree', {'expression': ''})
        result = json.loads(result)
        self.ventanas = result
        count = 0
        tab = []
        for x in result['result']['frameTree']['childFrames']:
            y = x['frame']
            tab.append( [str(count), y['name'], y['url'], y['id']] )
            count+=1
        print( tabulate(tab, ["id", "name", "url", "code"], tablefmt="orgtbl") )

    def pri(self):
        print(self.ventanas)

    def inject(self, code = '', contexto = None):
        print(code)
        if self.contextid == None:
            return
        if contexto == None:
            contexto = self.contextid

        kw = {
            "expression": str(code),
            "uniqueContextId": contexto,
            "allowUnsafeEvalBlockedByCSP": False
        }

        asyncio.get_event_loop().run_until_complete(self.send('Runtime.evaluate', kw))
    
    def injec(self):
        asyncio.get_event_loop().run_until_complete(mai.conseguir_ventanas())
        print('\nEnter ID of targeted script')
        idd = int(input('> '))
        asyncio.get_event_loop().run_until_complete(mai.conseguir_contexts(int(idd)))

    def open_casinoexploit(self):
        window = CasinoExploit(self)
        window.grab_set()



class CasinoExploit(tk.Toplevel):
    
    def __init__(self, parent):
        super().__init__(parent)
        self.parent = parent
        self.geometry('300x200')
        self.title('Toplevel Window')
        

        OPTIONS = []
        for x in parent.ventanas['result']['frameTree']['childFrames']:
            OPTIONS.append(x['frame']['url'])

        self.variable = StringVar(self)
        self.variable.set("Select Casino Script") # default value
        w = OptionMenu(self, self.variable, *OPTIONS)
        w.pack()

        button = Button(self, text="Get marks", command=self.ok)
        button.pack()

        self.casinomarksinput = Text(self)

        self.casinomarksinput.place(x=50, y=10, height=50, width=100)
        self.casinomarksinput.pack()
        
        ttk.Button(self,
                text='Close',
                command=self.destroy).pack(expand=True)
    def ok(self):

        casinomark = self.casinomarksinput.get("1.0",END)
        for x in self.parent.ventanas['result']['frameTree']['childFrames']:
            if x['frame']['url'] == self.variable.get():
                frameid = x['frame']['id']
                break
        
        result = asyncio.get_event_loop().run_until_complete( self.parent.send('Runtime.enable', {}) )
        for x in result:
            y=json.loads(x)
            try:
                if(frameid == y['params']['context']['auxData']['frameId']):
                    contexto = y['params']['context']['uniqueId']
            except:
                pass
        # payload = """"""
        # print(casinomark)
        print('joooder...')
        # print()

        payload = """fetch("http://chat/chatResult", {
  "headers": {
    "content-type": "application/json; charset=UTF-8"
  },
  "referrer": "",
  "referrerPolicy": "strict-origin-when-cross-origin",
  "body": "{"message":"cg1111111il","mode":"all"}",
  "method": "POST",
  "mode": "cors",
  "credentials": "omit"
});"""
        casinomark = payload
        print(type(casinomark))
        # if 
        
        self.parent.inject(casinomark, contexto)
        

# class CasinoExploit:
#     def __init__(self, master):
#         self.master = master
#         self.frame = tk.Frame(self.master)
#         self.quitButton = tk.Button(self.frame, text = 'Quit', width = 25, command = self.close_windows)
#         self.quitButton.pack()
#         self.frame.pack()
#     def close_windows(self):
#         self.master.destroy()



# root = tk.Tk()
mai = Principal()

mai.mainloop()





