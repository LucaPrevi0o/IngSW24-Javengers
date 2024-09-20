# Ingegneria del Software - Javengers
## Università degli Studi di Ferrara - Anno Accademico 2023-2024

<hr>

### Membri del team:
* **Luca Previati**: *ARCH*
* **Chiara Caselli**: *UX-UI*
* **Giovanni Pio Caterino**: *QA*
* **Wissal Kharbouchi**: *Data Analyst*

### Link:
* [Trello](https://trello.com/b/SFYsZ2Gy/javengers)
* [Demo video]()


>[!NOTE]
> Questo progetto utilizza una struttura monolitica (JSP, Java, MySQL) basata sul framework Spring.

>[!IMPORTANT]
> Per il corretto funzionamento dell'applicazione è necessario importare in MySQL il dump contenuto nella cartella *mysql-dump*.

<hr>

### Funzionalità del progetto: 
* Funzionalità **notifiche**:
   * Il progetto prevede una pagina principale "Notifiche" dalla quale l'utente può visualizzare le notifiche ricevute, con possibilità di filtrarle in base a tipo, username o contenuto, segnarle come lette o eliminarle.
   * L'utente può modificare le proprie preferenze sulle notifiche da ricevere, specificando quale tipo di notifica desidera ricevere tra *Eventi*, *Follower*, *Messaggi*, *Pagamenti*.
   * Ogni pagina prevedere un'icona *campanella* in alto a destra, con un menu drop-down contenente le notifiche non lette dell'utente.
   * *Notifiche push*: pop-up alla ricezione della notifica con riproduzione di un breve jingle, può essere chiuso manualmente o si chiude automaticamente dopo 10 secondi.
* Funzionalità **following**:
   * Possibilità di seguire altri utenti cliccando su un pulsante "Segui" sul profilo corrispondente.
   * Possibilità di rimuovere il follow cliccando su un pulsante "Smetti di seguire".
   * Ogni profilo utente contiene la lista di utenti seguiti/che si sta seguendo, con relativo counter.
   * Possibilità di bloccare o sbloccare utenti, con visualizzazione della lista di utenti bloccati all'interno di una pagina di impostazioni.

<hr>

### Screenshots:
![Screenshot from 2024-09-21 00-37-16](https://github.com/user-attachments/assets/7cacef33-2a39-4dda-88f5-9d2b582d9373)

![Screenshot from 2024-09-21 00-38-46](https://github.com/user-attachments/assets/a798fbc4-3a97-4e49-8cfb-b928176c4029)

![Screenshot from 2024-09-21 00-38-11](https://github.com/user-attachments/assets/69d5a1fd-da34-4c9d-8705-4824314570be)
