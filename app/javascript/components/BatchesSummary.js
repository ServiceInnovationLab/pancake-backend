import React from 'react';
import dateFns from 'date-fns';
import { map } from 'lodash';
import {
  Accordion,
  AccordionItem,
  AccordionItemHeading,
  AccordionItemButton,
  AccordionItemPanel,
} from 'react-accessible-accordion';

// Demo styles, see 'Styles' section below for some notes on use.
// import 'react-accessible-accordion/dist/fancy-example.css';

import { BatchRow } from './BatchRow';

export function BatchesSummary(batches, isDiaUser, isCouncilUser) {

  return (
    <Accordion allowZeroExpanded={true} className="batches-accordion">
      {map(batches, batch => {
        const {
          name,
          batch_date,
          rebate_forms,
          download_link,
          id
        } = batch;
        return (
          <AccordionItem key={name}>
            <AccordionItemHeading>
              <AccordionItemButton>
                <div className='batches-accordion-header-title'>
                  {name}
                  {isCouncilUser && <button
                    className='batches-accordion-header-button'
                    onClick={() => {
                      window.location = `/admin/batches/${id}/edit`;
                    }}>
                      Edit
                  </button>}
                </div>
                <div className='batches-accordion-header-row'>{dateFns.format(batch_date, 'DD MMM YYYY')} | {rebate_forms.length} Applications</div>
                <br/>
                {/* <div className='batches-accordion-header-row'>
                  {download_link ? <button>COVER SHEET</button> : 'Cover sheet required'}
                  {isDiaUser && <button>APPLICATIONS</button>}
                </div> */}

              </AccordionItemButton>
            </AccordionItemHeading>
            <AccordionItemPanel>
              { map(rebate_forms, (rebateForm) => BatchRow(rebateForm, isDiaUser))}
            </AccordionItemPanel>
          </AccordionItem>
        );
      })}

    </Accordion>
  );
}