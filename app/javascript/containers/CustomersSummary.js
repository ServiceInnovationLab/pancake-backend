
import React, { Fragment } from 'react';
import 'isomorphic-fetch';

import { getCSRF } from '../helpers/getCSRF';
import { SummaryTable } from '../components/SummaryTable';
import { SummarySearch } from '../components/SummarySearch';
import { SummaryTabs } from '../components/SummaryTabs';

const appUrl = window.location.origin;

class CustomersSummary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { checked: [], rebateForms: null, applicationState: 'not-completed' };
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

  fetchRebates (status, name = '') {
    fetch(`${appUrl}/admin/rebate_forms?utf8=✓&completed=${status}&name=${name || ''}`, {
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
        this.setState({ rebateForms: JSON.parse(data.json) });
      });
  }

  onChange(value) {
    const signed = value === 'completed'; 
    if(signed) {
      this.setState({applicationState: value});
      this.fetchRebates(signed);
    }
    else {
      this.setState({applicationState: value, rebateForms: null});
    }
  }

  fetchRebatesByName(values = {}) {
    this.fetchRebates(false, values.name);
  }

  render() {
    const { applicationState, rebateForms, checked } = this.state;
    const processable = applicationState === 'processed' &&
    (rebateForms && rebateForms[0]);

    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          {SummaryTabs(applicationState, this.onChange.bind(this))}          
          { !(applicationState === 'completed') && SummarySearch(this.fetchRebatesByName.bind(this))}
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
