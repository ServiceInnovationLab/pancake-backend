
import React, { Fragment } from 'react';
import 'isomorphic-fetch';

import { requestBuilder } from '../helpers/requestBuilder';

import { SummaryTable } from '../components/SummaryTable';
import { SummarySearch } from '../components/SummarySearch';
import { SummaryTabs } from '../components/SummaryTabs';

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
    requestBuilder({
      method: 'DELETE',
      path: '/admin/unprocess_rebate_forms',
      body: JSON.stringify({ids: this.state.checked})
    }).then(() => {
      this.setState({checked: []});
      this.fetchRebates(this.state.applicationState);
    });
  }

  fetchRebates (status, name) {
    requestBuilder({
      method: 'get',
      path: `/admin/rebate_forms?utf8=✓&status=${status}&name=${name || ''}`,
    })
      .then(response => {
        return response.json();
      })
      .then(data => {
        this.setState({ rebateForms: JSON.parse(data.json) });
      })
      .catch(error => {
        console.error(error);
      });
  }

  
  onChange(value) {
    this.setState({applicationState: value, rebateForms: null});

    if(value === 'not signed') return;

    this.fetchRebates(value);
  }

  fetchRebatesByName(values = {}) {  
    this.fetchRebates('not signed', values.name);
  }

  render() {
    const { applicationState, rebateForms, checked } = this.state;
    const processable = applicationState === 'processed' &&
    (rebateForms && rebateForms[0]);
    const checkIt = processable ? this.checkIt.bind(this) : null;
    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          {SummaryTabs(applicationState, this.onChange.bind(this))}          
          { (applicationState === 'not signed') && SummarySearch(this.fetchRebatesByName.bind(this))}
        </div>
        <div className='flex-row rebate-bulk-actions'>
          <h3>Search Results</h3>
          {processable && <button className='rebate-bulk-action-button' disabled={!checked[0]} onClick={this.unProcessRebates.bind(this)}>UNPROCESS</button>}
          {/* {processable && <button className='rebate-bulk-action-button' disabled={!checked[0]}>CREATE BATCH</button>} */}
        </div>
        {(rebateForms && rebateForms[0]) && SummaryTable(rebateForms, this.state, checkIt)}
      </Fragment>
    );
  }
}

export default CustomersSummary;
