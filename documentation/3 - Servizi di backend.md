# 3. Servizi di backend

[3.1 Architettura del servizio e REST API degli endpoint](#architettura)

[3.2 Autenticazione e autorizzazione](#autenticazione)

[3.3 Persistenza dei dati](#persistenza)


# Architettura

Il backend di GeoPic è stato interamente realizzato attraverso i servizi messi a disposizione dalla piattaforma Firebase.


I servizi utilizzati:

- <b>Authentication</b>: mette a disposizione una serie di servizi per poter gestire l'autenticazione degli utenti con il backend. Tra i vari servizi presenti si è scelto di utilizzare l'autenticazione standard con e-mail e password presente nell'SDK. 

- <b>RealTime Database</b>: database cloud-hosted NoSQL che gestisce i dati sottoforma di documenti JSON. Questo servizio è stato utilizzato per poter conservare i dati di ogni utente (aggiuntivi rispetto ai dati necessari per l'autenticazione) e i dati di ogni foto georeferenziata.

- <b>Storage</b>: servizio che fornisce uno spazio di archiviazione per File ben integrato con gli altri prodotti della piattaforma Storage. È stato utilizzato per lo storage dei file immagine relativi alle foto georeferenziate.

Tutti questi servizi hanno notevoli pregi riguardanti la <b>robustezza</b>, <b>sicurezza</b> e <b>scalabilità</b> delle operazioni. Aspetti che verranno trattati nel dettaglio nei punti 3.2 e 3.3 con la discussione delle rules inserite. 


# GeoPic REST API

## Authentication Endpoint

/auth

[Signup](#signup)

[Login](#login)

[Delete Account](#deleteaccount)

[Cambio Password](#cambiopassword)

[Recupero Password](#ripristinopassword)

## RealTime Database Endpoint 
/users

[Create User](#createuser)

[Read User](#readuser)

[Update User](#updateuser)

[Delete User](#deleteuser)

/photos

[Create Photo](#createphoto)

[Read Photo](#readphoto)

[Update Photo](#updatephoto)

[Delete Photo](#deletephoto)

[Get Personal Gallery](#getpersonalgallery)

[Get All Photos](#getallphotos)

## Storage Endpoint

/SharedPhotos

[uploadimage](#uploadimage)

[downloadimage](#downloadimage)

# signup

Metodo che consente ad un generico utente di registrarsi presso l'endpoint di autenticazione.

* **URL:**
        
        https://identitytoolkit.googleapis.com/v1/accounts:signUp

* **Method:**
  
        POST
  
*  **Query params:**

        key: AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU        //API web key del progetto GeoPic
    
   
* **Body (Json):**
 
        {
        "email": "user@example.com",        //Deve essere ben formata nel formato[A-Z,0-9]+@+
        "password": "password",             //Deve essere di almeno 6 caratteri
        "returnSecureToken": "true"
        }

    

* **Success Response:**
        
        {
        "idToken": "[ID_TOKEN]",        
        "email": "[user@example.com]",      
        "refreshToken": "[REFRESH_TOKEN]",
        "expiresIn": "3600",
        "localId": "[Local_id]"
        }
        
        Code: 200 OK

Nella risposta viene fornito <b>local id</b> che identifica l'utente all'interno del sistema e l'<b>idToken</b> (con expiration time di 1h) che serve per autenticare le richieste inviate dall'utente presso gli altri endpoint REST.
 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request

        Possibili contenuti del messaggio d'errore:

      - EMAIL_EXISTS: l'indirizzo email è già utilizzato da un altro account.
      - OPERATION_NOT_ALLOWED: l'accesso con password è disabilitato per questo progetto.
      - TOO_MANY_ATTEMPTS_TRY_LATER: abbiamo bloccato tutte le richieste da questo dispositivo a causa di attività insolite. Riprovare più tardi.

* **Example:**
  
        curl --location --request POST 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "email": "postman1@post.com",
            "password": "password",
            "returnSecureToken": "true"
        }



# login

Metodo che consente ad un utente registrato di accedere ed ottenere un idtoken temporaneo.

* **URL:**
        
        https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword

* **Method:**
  
        POST
  
*  **Query params:**

        key: AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU        //API web key del progetto GeoPic
    
   
* **Body (Json):**
 
        {
        "email": "user@example.com",        //Deve essere ben formata nel formato[A-Z,0-9]+@+
        "password": "password",             //Deve essere di almeno 6 caratteri
        "returnSecureToken": "true"
        }

    

* **Success Response:**
        
        {
        "idToken": "[ID_TOKEN]",        
        "email": "[user@example.com]",      
        "refreshToken": "[REFRESH_TOKEN]",
        "expiresIn": "3600",
        "localId": "[Local_id]"
        }
        
        Code: 200 OK

Nella risposta viene fornito <b>local id</b> che identifica l'utente all'interno del sistema e l'<b>idToken</b> (con expiration time di 1h) che serve per autenticare le richieste inviate dall'utente presso gli altri endpoint REST.
 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request

        Possibili contenuti del messaggio d'errore:

      - EMAIL_NOT_FOUND: nessun record utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.
      - INVALID_PASSWORD: la password non è valida o l'utente non dispone di una password.
      - USER_DISABLED: l'account utente è stato disabilitato da un amministratore.

* **Example:**
  
        curl --location --request POST 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "email": "postman1@post.com",
            "password": "password",
            "returnSecureToken": true
        }'

# deleteaccount

Metodo che consente ad un utente registrato di eliminare il suo account.

* **URL:**
        
        https://identitytoolkit.googleapis.com/v1/accounts:delete

* **Method:**
  
        POST
  
*  **Query params:**

        key: AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU        //API web key del progetto GeoPic
    
   
* **Body (Json):**
 
        {
        "idToken":[TOKEN_ID]        //Recuperato attraverso login
        }

    

* **Success Response:**
        
        {
        "kind": "identitytoolkit#DeleteAccountResponse"
        }
        
        Code: 200 OK

 
* **Error Response:**

        Code: 401 Unauthorized / 400 BAD REQUEST

        Possibili contenuti del messaggio d'errore:

      - INVALID_ID_TOKEN: le credenziali dell'utente non sono più valide. L'utente deve eseguire nuovamente l'accesso.
      - USER_NOT_FOUND: nessun record utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.

* **Example:**
  
        curl --location --request POST 'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmRmMjQxZTdjM2E2NTEzNTYwNmR...."
        }'

# cambiopassword

Metodo che consente ad un utente registrato di cambiare la sua password

* **URL:**
        
        https://identitytoolkit.googleapis.com/v1/accounts:update

* **Method:**
  
        POST
  
*  **Query params:**

        key: AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU        //API web key del progetto GeoPic
    
   
* **Body (Json):**
 
        {
        "idToken": [ID_TOKEN]               //ID token assegnato all'utente attraverso login
        "password": "password",             //Deve essere di almeno 6 caratteri
        "returnSecureToken": "true"
        }

    

* **Success Response:**
        
        {
            "localId": "tRcfmLH7o2...",
            "email": "[user@example.com]",
            "passwordHash": "...",
            "providerUserInfo":
         [     
            {
                "providerId": "password",
                "federatedId": "[user@example.com]"
            }
        ],
            "idToken": "[NEW_ID_TOKEN]",
            "refreshToken": "[NEW_REFRESH_TOKEN]",
            "expiresIn": "3600"
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request

        Possibili contenuti del messaggio d'errore:

      - INVALID_ID_TOKEN: le credenziali dell'utente non sono più valide. L'utente deve eseguire nuovamente l'accesso.
      - WEAK_PASSWORD: la password deve essere lunga almeno 6 caratteri.

* **Example:**
  
        curl --location --request POST 'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU' \
        --header 'Content-Type: application/json' \
        --data-raw ' {
        "idToken":  "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmRmMjQxZTdjM2E2NTEzNTYwNmRkYzFmZWQyYzU1MjI2 MzBhODciLCJ0e........",               
        "password": "NewPassword!",        
        "returnSecureToken": "true"
        }'


# ripristinopassword

    Metodo che consente ad un utente registrato di ripristinare la sua password attraverso la sua e-mail.

* **URL:**
        
        https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode

* **Method:**
  
        POST
  
*  **Query params:**

        key: AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU        //API web key del progetto GeoPic
    
   
* **Body (Json):**
 
        {
        "requestType":"PASSWORD_RESET",            
        "email":"[user@example.com]",            //e_mail con cui ci si è registrati
        }

    

* **Success Response:**
        
        {
        "kind": "identitytoolkit#GetOobConfirmationCodeResponse",
        "email": "[user@example.com]",  
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request

        Possibili contenuti del messaggio d'errore:

      - EMAIL_NOT_FOUND: nessun record utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.

* **Example:**
  
        curl --location --request POST 'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyCDRRXmgliOPDajRA70W37_rFVfsndQtOU' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "requestType":"PASSWORD_RESET",            
            "email":"postman1@post.com"
        }
        '

# createuser

Metodo che consente ad un utente registrato presso l'endpoint di autenticazione di caricare i suoi dati personali.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/[Local Id].json

* **Method:**
  
        PUT
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
    
   
* **Body (Json):**
 
        { 
            "email": "user@example.com",   //Deve essere ben formata 
            "username": "newUsername"         //Inferiore a 20 caratteri
        }

    

* **Success Response:**
        
        {
            "email": "user@example.com",
            "username": "newUsername"
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
        
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo. 


* **Example:**
  
        curl --location --request PUT 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/ysJyCMnqISSq7nC6oIuzPWCvgvA3.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmR...' \
        --header 'Content-Type: application/json' \
        --data-raw '{ 
            "email": "postman1@post.com",
            "username": "postman3"
        }'

# readuser

Metodo che consente ad un utente registrato presso l'endpoint di autenticazione e per cui esista il record nel database di ottenere i suoi dati personali.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/[Local Id].json

* **Method:**
  
        GET
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        {
            "email": "user@example.com",
            "username": "postman3"
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito

        Code: 200 con payload nullo significa che l'uri specificata non corrisponde a nessuna risorsa
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request GET 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/ysJyCMnqISSq7nC6oIuzPWCvgvA3.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6Ijh.....'


# updateuser

Metodo che consente ad un utente registrato presso l'endpoint di autenticazione e per cui esista il record nel database di modificare il suo username e/o la sua password.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/[Local Id].json

* **Method:**
  
        PATCH
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        
* **Body(JSON):**
        
        {
            "email": "newuser@example.com",        //la nuova email, deve essere ben formata
            "username": "newUsername"       //il nuovo username, di massimo 20 caratter
        }


* **Success Response:**
        
        {
            "email": "newuser@example.com",
            "username": "newUsername"
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request PATCH 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/ysJyCMnqISSq7nC6oIuzPWCvgvA3.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI...' \
        --header 'Content-Type: application/json' \
        --data-raw '{
            "email": "postman1@post.com",
            "username": "NewUserna"
        }'



# deleteuser

Metodo che consente ad un utente registrato presso l'endpoint di autenticazione e per cui esista il record nel database di eliminare i suoi dati.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/[Local Id].json

* **Method:**
  
        DELETE
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        null

        200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request DELETE 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/ysJyCMnqISSq7nC6oIuzPWCvgvA3.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmRmMjQ...'


# createphoto

Metodo che consente ad un utente registrato di caricare una foto georeferenziata sul sisitema.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/[Local Id].json

* **Method:**
  
        POST
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
    
   
* **Body (Json):**
 
        {
                "Userid": "ysJyCMnqISSq7nC6oIuzPWCvgvA3",               //Deve coincidere con quello dell'utente che sta caricando la foto e con il local Id presente nell'url
                "description": "postman try4",          //Testo di massimo 100 caratteri
                "downloadUrl": [url],           //Url dell'immagine, recuperata attraverso upload di un'immagine sullo storage
                "lat": 0.0,             //Compreso tra -90 e 90
                "lon": 0.0,             //Compreso tra -180 e 180
                "place": "postmantry",          //Stringa di massimo 30 caratteri
                "username": "Postman3"          //Stringa di massimo 20 caratteri                   
        }

    

* **Success Response:**
        
        {
                "name": "-MmMN0QZjGy2tZJXwW8R"          //Id autogenerato dal metodo post che indica la posizione in cui è stata caricata la foto
        }       
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
        
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo. 


* **Example:**
  
        curl --location --request POST 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/ysJyCMnqISSq7nC6oIuzPWCvgvA3.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6Ij....' \
        --header 'Content-Type: application/json' \
        --data-raw '{
                "Userid": "ysJyCMnqISSq7nC6oIuzPWCvgvA3",
                "description": "postman try",
                "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                "lat": 0.0,
                "lon": 0.0,
                "place": "postman",
                "username": "PostmanTry"
        }'

# readphoto

Metodo che consente ad un utente registrato di ottenere i dati relativi ad una particolare foto.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/[Local Id]/[photo Id].json

* **Method:**
  
        GET
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        {
                "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                "description": "postman try4",
                "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                "lat": 0.0,
                "lon": 0.0,
                "place": "postmantry",
                "username": "Postman3"
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito

        Code: 200 con payload nullo significa che l'uri specificata non corrisponde a nessuna risorsa
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request GET 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/fbU0Czt8uuoOMASrmGl2/-MmMN0QZjGy2tZJXwW8R.json?auth=eyJhbGciOiJSUzI1NiIsImtpZC....'


# updatephoto

Metodo che consente ad un utente registrato di aggiornare i dati relativi ad una foto che ha caricato il precedenza
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/[Local Id]/[photo Id].json

* **Method:**
  
        PATCH
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        
* **Body(JSON):**
        
        {
                "Userid": "ysJyCMnqISSq7nC6oIuzPWCvgvA3",               //Deve coincidere con quello dell'utente che sta modificando la foto e con il local Id presente nell'url
                "description": "postman patch",          //Testo di massimo 100 caratteri
                "downloadUrl": [url],           //Url dell'immagine, recuperata attraverso upload di un'immagine sullo storage
                "lat": 3.0,             //Compreso tra -90 e 90
                "lon": 0.0,             //Compreso tra -180 e 180
                "place": "postmantry",          //Stringa di massimo 30 caratteri
                "username": "Postman11"          //Stringa di massimo 20 caratteri                   
        }


* **Success Response:**
        
        {
                "username": "Postman11",
                "description": "postman patch",
                "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                "lon": 0.0,
                "place": "postmantry",
                "lat": 3.0
        }
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request PATCH 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/fbU0Czt8uuWzZB9CvXoOMASrmGl2/-MmMN0QZjGy2tZJXwW8R.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmRmMjQxZTdjM2E2N....' \
        --header 'Content-Type: application/json' \
        --data-raw '{
                "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                "description": "postman patch",
                "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                "lat": 3.0,
                "lon": 0.0,
                "place": "postmantry",
                "username": "Postman11"
        }'



# deletephoto

Metodo che consente ad un utente registrato di eliminare una foto caricata in precedenza.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/users/[Local Id]/[Photo_id].json

* **Method:**
  
        DELETE
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        null

        200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request DELETE 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/fbU0Czt8uuWzZB9CvXoOMASrmGl2.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6.....'


# getpersonalgallery

Metodo che consente ad un utente registrato di ottenere tutti i dati relativi alle foto che ha caricato sul sistema.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b> e il suo <b>Local Id</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/[Local Id].json

* **Method:**
  
        GET
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        {
                "-MmMRRP4RdUg7bOy2plN": {
                        "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                        "description": "postman try4",
                        "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                        "lat": 0.0,
                        "lon": 0.0,
                        "place": "postman1",
                        "username": "Postman1"
                },
                "-MmMRSo1CUmJ7f6U4rw4": {
                        "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                        "description": "postman try4",
                        "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                        "lat": 0.0,
                        "lon": 0.0,
                        "place": "postman2",
                        "username": "Postman2"
                },
                "-MmMRV39G1NlkJsTIOmq": {
                        "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                        "description": "postman try4",
                        "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                        "lat": 0.0,
                        "lon": 0.0,
                        "place": "postman3",
                        "username": "Postan3"
                }
        }       
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il local id dell'url non coincide con quello dell'utente autenticato
        - il payload del messaggio non rispetta il formato prestabilito

        Code: 200 con payload nullo significa che l'uri specificata non corrisponde a nessuna risorsa
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request GET 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/fbU0Czt8uuWzZB9CvXoOMASrmGl2.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...'


# getallimages

Metodo che consente ad un utente registrato di ottenere tutti i dati relativi alle foto caricate sul sistema.
È necessario che l'utente abbia effettuato un login da meno di un ora e che abbia a portata di mano un <b>TOKEN-ID</b>.

* **URL:**
        
        https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos.json

* **Method:**
  
        GET
  
*  **Query params:**

        auth: [TOKEN_ID]        //recuperato attraverso login
        

* **Success Response:**
        
        {
        "FgPfibBybAbUFNWFjt0Mnyy7ut42": {
                "FgPfibBybAbUFNWFjt0Mnyy7ut421634588897676": {
                "Userid": "FgPfibBybAbUFNWFjt0Mnyy7ut42",
                "description": "torre pendente di Pisa",
                "downloadUrl": "https://firebasestorage.googleapis.com/v0/b/geopic-f1080.appspot.com/o/SharedPhotos%2FThe_Leaning_Tower_of_Pisa_SB.jpeg.jpeg?alt=media&token=2355ae99-58f8-499c-8c2d-ab318ed48fac",
                "lat": 43.7132856,
                "lon": 10.4176849,
                "place": "Torre di Pisa",
                "username": "postman3"
                }
        },
        "eTsLy1cEfTZH5mJ8L3ZRtWV3m822": {
                "eTsLy1cEfTZH5mJ8L3ZRtWV3m8221634562845920": {
                "Userid": "eTsLy1cEfTZH5mJ8L3ZRtWV3m822",
                "description": "Monumento Morcone",
                "downloadUrl": "https://firebasestorage.googleapis.com/v0/b/geopic-f1080.appspot.com/o/SharedPhotos%2Fscaled_image_picker417485308636101194.jpg?alt=media&token=5fba9085-7321-49da-a117-33e3c9dcb6bc",
                "lat": 41.3295876,
                "lon": 14.6624662,
                "place": "Morcone",
                "username": "postman2"
                }
        },
        "fbU0Czt8uuWzZB9CvXoOMASrmGl2": {
                "-MmMRV39G1NlkJsTIOmq": {
                "Userid": "fbU0Czt8uuWzZB9CvXoOMASrmGl2",
                "description": "postman try3",
                "downloadUrl": "https://randomwordgenerator.com/img/picture-generator/57e5d2424a54a414f1dc8460962e33791c3ad6e04e507440762e7adc904cc6_640.jpg",
                "lat": 0.0,
                "lon": 0.0,
                "place": "postman3",
                "username": "Marco Ruta"
                }
        }
        }     
        
        Code: 200 OK


 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto

        Code: 200 con payload nullo significa che l'uri specificata non corrisponde a nessuna risorsa
     
        Per errori dovuti dalle rules presenti nel database verrà restituito un generico errore 401, negli altri casi l'errore viene accompagnato da un messaggio esplicativo.


* **Example:**
  
        curl --location --request GET 'https://geopic-f1080-default-rtdb.europe-west1.firebasedatabase.app/photos/fbU0Czt8uuWzZB9CvXoOMASrmGl2.json?auth=eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...'


# uploadimage

Metodo che consente ad un utente registrato di caricare un file immagine sullo storage. Prima di poter caricare il file è necessario ottenere un token di autorizzazione OAuth2.0 Playground qui: https://developers.google.com/oauthplayground/

* **URL:**
        
        https://storage.googleapis.com/upload/storage/v0/b/geopic-f1080.appspot.com/o/SharedPhotos

* **Method:**
  
        POST
  
*  **Query params:**

        uploadType: media     
        name: imageName

*  **Headers:**

        Authorization: OAUTH2_TOKEN             //recuperato il precedenza    
        Content-type: object content type

* **Body(binary):**
        
        {
                "file" : Object_location                //local path dell'oggetto                
        }
        

* **Success Response:**
        
                {
                 "downloadUrl":"https://firebaseStorage...."       
                }
        
        
                
                Code: 200 OK




 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
        - il payload del messaggio non rispetta il formato prestabilito



* **Example:**
  
        curl -X POST --data-binary @MULTIPART_FILE_LOCATION \
        -H "Authorization: Bearer OAUTH2_TOKEN" \
        -H "Content-Type: multipart/related; boundary=BOUNDARY_STRING" \
        -H "Content-Length: MULTIPART_FILE_SIZE" \
        "https://storage.googleapis.com/upload/storage/v1/b/BUCKET_NAME/o?uploadType=multipart"

# downloadimage

Metodo che consente ad un utente di scaricare una foto presente nello storage. L'url della foto sullo storage si può recuperare nel realtimedatabase nel campo downloadUrl della collezione photos.

* **URL:**
        
        https://storage.googleapis.com/storage/v0/b/geopic-f1080.appspot.com/o/SharedPhotos

* **Method:**
  
        GET
  

*  **Headers:**

        Authorization: OAUTH2_TOKEN             //recuperato il precedenza    



* **Success Response:**

        *Image*

        Code: 200 OK




 
* **Error Response:**

        Code: 401 Unauthorized || 400 Bad Request
        L'errore può dipendere da diversi fattori:
        - Token di accesso non valido/scaduto
      



* **Example:**
  
        curl -X GET \
        -H "Authorization: Bearer OAUTH2_TOKEN" \
        -o "SAVE_TO_LOCATION" \
        "https://storage.googleapis.com/storage/v1/b/BUCKET_NAME/o/OBJECT_NAME?alt=media"



# Autenticazione
L'autenticazione e l'autorizzazione sono interamente gestite attraverso il servizio Authentication by Firebase. <br> Un utente prima di poter accedere al sistema e di poter caricare i suoi dati personali o una foto georeferenziata deve <b>necessariamente</b> registrarsi presso l'endpoint di autenticazione e recuperare un token di accesso valido. 
<br>
<br>
Quando un nuovo utente si <b>registra</b> sul sistema viene generato un nuovo <b>local Id</b> che sarà identificativo univoco dell'utente all'interno del sistema.
<br>
<br>
Quando un utente registrato effettua il <b>login</b> il sistema fornisce all'utente un <b>Token Id</b> che potrà essere utilizzato dall'utente per autenticare le richieste presso gli endpoint del sistema.
<br>
<br>
Le regole di autenticazione e autorizzazione sono gestite attraverso le <b>rules</b> presenti nel realtime database e nello storage. <br><br> Per quanto riguarda le autorizzazioni:

        "users": {
        "$user": {
        ".read": "auth.uid === $user",
        ".write": "auth.uid === $user",

L'accesso ai dati dell'utente è limitato all'utente stesso sia in scrittura sia in lettura. lo schema di accesso è Attribute-Based, di ogni richiesta si controlla se il Local-id dell'utente coincide con quello associato al Token-id della richiesta. 

        "photos": {
        ".read": "auth.uid != null",
        
        "$user":{
        ".write": "auth.uid === $user",
        ".read": "auth.uid != null",

L'accesso in <b>lettura</b> ai dati delle foto georeferenziate è consentito a tutti gli utenti correttamente autenticati. L'accesso in <b>scrittura</b> al personal bucket di ogni utente (photos/local_id) è limitato all'utente stesso attraverso uno schema di accesso Attribute based in cui si va controllare se il Local-id dove si vuole postare la foto corrisponde con quello associato al Token-id della richiesta.

        rules_version = '2';
        service firebase.storage {
                match /b/{bucket}/o {
                        match /{allPaths=**} {
                                allow read, write: if request.auth != null;
                        }
                }
        }

L'upload e il download di immagini sullo storage è consentito a qualsiasi utente autenticato in quanto lo storage consisite in un singolo bucket (SharedPhoto) e non presenta alcun tipo di strutturazione.



# Persistenza

la gestione dei dati persistenti è stata realizzata attraverso realtime database e storage by Firesbase.<br><br>
Il servizio <b>RealTimeDatabase</b> mette a disposizione un database NoSQL che mantiene i dati sottoforma di documenti JSON. Le caratteristiche più importanti di questo servizio sono: 
- RealTime Updates: consente di scambiare dati attraverso sincronizzazione real time con il client ogni volta che i dati cambiano sul server.
- Offline usage: le App firebase continuando a funzionare anche in assenza di connettività in quanto tutti i dati vengono mantenuti in locale. Una volta ripristinata la connessione il client riceve tutte le modifiche perse sincronizzando il proprio stato con quello del server.
- Direct client accessibility: per poter utilizzare il realtime database non è necessario realizzare un application server. Il database è contattabile da qualsiasi tipo di client e l'autorizzazione delle richieste e la convalida dei dati vengono gestiti attraverso le rules.

Le collezioni presenti nel realtime database sono strutturate come segue:<br>

<img src = "images/backend/realtime_structure.png" align="center"> <br>

Le varie collezioni sono protetette e validate attraverso le seguenti rules.
<br>- Attraverso <b>.read</b> e <b>.write</b> si gestisce l'autenticazione e l'autorizzazione delle richieste  ,
<br> - Attraverso <b>.validate</b> si verifica la consistenza dei dati.

       {
        "rules": {
       
        "users": {
                "$user": {
                ".read": "auth.uid === $user",
                ".write": "auth.uid === $user",
                ".validate": "newData.hasChildren(['email', 'username'])",
                        "email":{
                        ".validate": "newData.isString() && newData.val().matches(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$/i)"
                        },  
                        "username":{
                        ".validate": "newData.isString()",
                         }
                }
        },
        "photos": {
                ".read": "auth.uid != null",

                "$user":{
                ".write": "auth.uid === $user",
                ".read": "auth.uid != null",
      
                        "$photo": {
                        ".validate": "newData.hasChildren(['Userid', 'description','downloadUrl','lat','lon','place','username'])",
                                "Userid":{
                                        ".validate": "newData.isString() && newData.val() === auth.uid",
                                },
                                "description":{
                                        ".validate": "newData.isString() && newData.val().length < 100",
                                },
                                "lat":{
                                        ".validate": "newData.isNumber() && newData.val()>=-90 && newData.val() <= 90",
                                        },
                                "lon":{
                                        ".validate": "newData.isNumber() && newData.val()>=-180 && newData.val() <= 180",
                                        },
                                "palce":{
                                        ".validate": "newData.isString() && newData.val().length < 30",
                                },
                                                "username":{
                                ".validate": "newData.isString() && newData.val().length < 21",
                                }
                        }
                }
        }
        }
        }


Il servizio <b>Storage</b> by Firebase mette a disposizione uno spazio di archiviazione in cloud perfettamente integrato con gli altri servizi del pacchetto Firebase. <br>
L'utilizzo di questo servizio è stato minimale, lo si è sfruttato solamente per avere a disposizione una directory di salvataggio dei file immagine che garantisse buone performance.<br>
Le immagini caricate sono relative al campo "downloadUrl" di ogni foto georeferenziata presente in realtime/photos e sono mantenute all'interno della directory /SharedPhotos

<img src = "images/backend/storage_structure.png" align="center"> <br>

Per garantire la consistenza dello storage l'upload e il download di file sono consentiti solo ad utenti autenticati con il sistema. <br>Viene eseguito un controllo sul file caricato per far si che sia un immagine e che non abbia dimensioni esagerate.

        rules_version = '2';
        service firebase.storage {
                match /b/{bucket}/o {
                        match /{allPaths=**} {
                        allow read, write: if request.auth != null;
        
                        match /SharedPhotos/{imageId} {

                                allow write: if request.resource.size < 10 * 1024 * 1024 && request.resource.contentType.matches('image/.*');
                                }
        }
        
        }
        }
