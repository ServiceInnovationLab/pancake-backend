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
          created_at,
          rebate_forms,
          header_sheet_attached,
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
                <div className='batches-accordion-header-row'>{dateFns.format(created_at, 'DD MMM YYYY')} | {rebate_forms.length} Applications</div>
                <br/>
                <div className='batches-accordion-header-row'>
                  {header_sheet_attached
                    ? <a
                      target='_blank'
                      rel='noopener'
                      href={download_link}
                      id='header-sheet'
                      className='batches-header-sheet-download-button'
                      download>
                      <img className='batches-download-icon' alt='blue download icon' src='/assets/blue-download.svg'/>
                        HEADER SHEET
                    </a>
                    : <div className='batches-header-sheet-required'>Header sheet required</div>
                  }
                  {isDiaUser && <a
                    target='_blank'
                    rel='noopener'
                    className='batches-applications-button'
                    onClick={() => {
                      window.open(`/admin/batches/${id}`);
                    }}>
                    <img className='batches-download-icon batch-download-icon' alt='blue download icon' src='/assets/blue-download.svg'/>
                      BATCH
                  </a>}
                </div>
                <div className='batches-applications-header'>APPLICATIONS</div>
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
