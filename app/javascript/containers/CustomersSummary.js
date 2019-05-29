
import React, { Fragment } from 'react';
import 'isomorphic-fetch';

import { getCSRF } from '../helpers/getCSRF';
import { getPath } from '../helpers/fetchRebatesPath'

import { SummaryTable } from '../components/SummaryTable';
import { SummarySearch } from '../components/SummarySearch';
import { SummaryTabs } from '../components/SummaryTabs';
const appUrl = window.location.origin;

class CustomersSummary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { checked: [], rebateForms: null, applicationState: 'not signed' };
  }
  
  checkIt (key) {
    const rebateFormId = this.state.rebateForms[key].id;
    let { checked } = this.state;

    const index = checked.indexOf(rebateFormId);
    
    index !== -1
      ? checked.splice(index, 1)
      : checked.push(rebateFormId);
    
    this.setState({
      checked: [...checked]
    });
  }

  unProcessRebates () {
    debugger
    // fetch(`${appUrl}/admin/rebate_forms/`, {
    //   method: 'PATCH',
    //   headers: {
    //     'X-CSRF-Token': getCSRF(),
    //     'Accept': 'application/json',
    //     'Content-Type': 'application/json'
    //   },
    //   body: JSON.stringify(this.state.checked),
    //   credentials: 'same-origin'
    // }).then(response => {
    //   return response.json();
    // }).then(data => {
    //   this.setState({ rebateForms: JSON.parse(data.json) });
    // });
  }

  fetchRebates (path) {
    fetch(`${appUrl}/admin/${path}`, {
      method: 'GET',
      headers: {
        'X-CSRF-Token': getCSRF(),
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
      .then(response => {
        return response.json();
      })
      .then(data => {
        console.log(data, data.json)
        this.setState({ rebateForms: JSON.parse(data.json) });
      })
      .catch(error => {
        console.error(error);
      });
  }

  
  onChange(value) {
    this.setState({applicationState: value, rebateForms: null});

    const path = getPath(value);

    this.fetchRebates(path);
  }

  fetchRebatesByName(values = {}) {  
    this.fetchRebates(`rebate_forms?utf8=✓&status=not signed&name=${values.name || ''}`);
  }

  render() {
    const { applicationState, rebateForms, checked } = this.state;
    const processable = applicationState === 'processed' &&
    (rebateForms && rebateForms[0]);

    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          {SummaryTabs(applicationState, this.onChange.bind(this))}          
          { !(applicationState === 'signed') && SummarySearch(this.fetchRebatesByName.bind(this))}
        </div>
        <div className='flex-row rebate-bulk-actions'>
          <h3>Search Results</h3>
          {processable && <button className='rebate-bulk-action-button' disabled={!checked[0]}>UNPROCESS</button>}
          {processable && <button className='rebate-bulk-action-button' disabled={!checked[0]}>CREATE BATCH</button>}
        </div>
        {(rebateForms && rebateForms[0]) && SummaryTable(rebateForms, this.state, this.checkIt.bind(this))}
      </Fragment>
    );
  }
}

export default CustomersSummary;
