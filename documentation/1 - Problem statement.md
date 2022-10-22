# Problem Statement

Sviluppare un sistema client-server (mobile + backend) per la creazione e la condivisione di 
<b>immagini georeferenziate</b> su luoghi di interesse (es. palazzi storici, piazze, monumenti).

Ogni immagine da inviare è accompagnata dai seguenti metadati (tutti obbligatori):
- nome del luogo
- una breve descrizione (max 100 caratteri)
- l'immagine
- la posizione geografica

La componente server, da realizzare utilizzando a scelta Vert.X , Spring, o i servizi Firebase, deve consentire 
mediante un opportuno servizio REST, le operazioni di:

- registrazione di un nuovo utente
- Login (mediante login/password come meccanismo di autenticazione)
- Upload di una immagine con i relativi metadati (previo login)

L'app mobile, da realizzarsi mediante Android SDK o il framework Flutter a scelta,  deve permettere le stesse 
operazioni (registrazione, login, upload) ed in aggiunta visualizzare su Google Maps i marker con le immagini caricate 
nei luoghi di interesse dagli altri utenti.