import { LightningElement, api } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AsyncToastNotification extends LightningElement {
    subscription = {};
    channelName = '/event/Async_Toast_Notification__e';
    @api recordId;

    // Initializes the component
    connectedCallback() {
        // Register error listener     
        console.log('AsyncToastNotification: recordId', this.recordId);
        this.registerErrorListener();
        this.handleSubscribe();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const thisReference = this;
        const recordId = this.recordId;
        const messageCallback = function (response) {
            var objEvnt = JSON.parse(JSON.stringify(response.data.payload));
            console.log('AsyncToastNotification: ', recordId);
            console.log('AsyncToastNotification: ', objEvnt.Object_Id__c);
            if (objEvnt.Object_Id__c == recordId || recordId.includes(objEvnt.Object_Id__c)) {
                console.log('objEvnt: ', objEvnt);
                thisReference.showToast(objEvnt.Title__c, objEvnt.Message__c, objEvnt.Type__c, objEvnt.Mode__c);
            }
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        onError(error => {
            console.error('Received error from server: ', JSON.stringify(error));
        });
    }

    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant ? variant : 'success',
            mode: mode ? mode : 'dismissable'
        });
        this.dispatchEvent(event);
    }
}