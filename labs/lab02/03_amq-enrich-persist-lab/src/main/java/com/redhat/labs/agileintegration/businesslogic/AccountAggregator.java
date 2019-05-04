package com.redhat.labs.agileintegration.businesslogic;

import org.apache.camel.Exchange;
import org.apache.camel.processor.aggregate.AggregationStrategy;
import org.apache.cxf.message.MessageContentsList;
import org.globex.Account;
import org.globex.Company;
import org.globex.CorporateAccount;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 * Aggregator implementation which extract the id and salescontact
 * from CorporateAccount and update the Account
 */
public class AccountAggregator implements AggregationStrategy {

    @Override
    public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {

        if (oldExchange == null) {
           // Account account = newExchange.getIn().getBody(Account.class);
           // newExchange.getIn().setBody(account);
            return newExchange;
        }

        if (oldExchange.getIn().getBody() instanceof String)  {
        	return newExchange;
        }
        CorporateAccount ca = newExchange.getIn().getBody(CorporateAccount.class);
        Account account = oldExchange.getIn().getBody(Account.class);


        //System.out.println("Geo is " + account.getCompany().getGeo() + "Client id is " + ca.getId() + ", sales rep is " + ca.getSalesContact());
        account.setClientId(ca.getId());
        account.setSalesRepresentative(ca.getSalesContact());
        oldExchange.getIn().setBody(account);

        return oldExchange;
    }

}
