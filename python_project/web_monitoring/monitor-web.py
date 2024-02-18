import requests
import smtplib
import paramiko
def notify(emailMSG):
       with smtplib.SMTP('smtp.gmail.com', 587) as smtp:
          smtp.starttls()
          smtp.ehlo()
          smtp.login("blibechmedamine@gmail.com", "blvc xhzo womd cldf")
          smtp.sendmail("blibechmedamine@gmail.com", "blibechmedamine@gmail.com", f"Subject: Site down\n {emailMSG}")

def restart_app():
    #restart the application (restart the docker container).
    # 1) connect to the instance with ssh that's why using lib Paramiko
    ssh =paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    ssh.connect(hostname="ec2-3-80-80-114.compute-1.amazonaws.com", username='ubuntu', key_filename="D:\python_project\web_monitoring\k2.pem")
    # start container
    stdin, stdout, stderr = ssh.exec_command('docker start Id')
    print(stdout.readlines())
    # close the ssh connection
    ssh.close()
    print('App restart')

#acces to the endpoint of the app
try:
   res = requests.get('https://3.80.80.114:3000')
 #to check accesible app
   if res.status_code == 200:
    print('Application is running successfully')
   else:
    print('Application is not running. fix it')
    #send email to me
    #IMAP port 993
    #SMTP port for SSL 456
    #SMTP port for TLS 587
    #with is alternative to try/finally statements
    msg = f'Application returned {res.status_code}'
    notify(msg)
    ## restart the application
    restart_app()

except Exception as ex:
    print(f'Connection erreur happend: {ex}')
    #notify the dev by the err system
    msg = "application is not accesible"
    notify(msg)
    restart_app()
