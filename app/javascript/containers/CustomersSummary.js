
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
    this.state = { rebateForms: null, applicationState: 'not signed' };
  }

  fetchRebates (status = 'not signed', name = '') {
    fetch(`${appUrl}/admin/rebate_forms?utf8=✓&status=${status}&name=${name || ''}`, {
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
    const signed = value === 'signed';
    if(signed) {
      this.setState({applicationState: value});
      this.fetchRebates(value);
    }
    else {
      this.setState({applicationState: value, rebateForms: null});
    }
  }

  onSubmit(values = {}) {
    this.fetchRebates('not signed', values.name);
  }

  render() {
    const { applicationState, rebateForms } = this.state;
    console.log(this.state, 'this state');
    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          {SummaryTabs(applicationState, this.onChange.bind(this))}
          { !(applicationState === 'signed') && SummarySearch(this.onSubmit.bind(this))}
        </div>
        {(rebateForms && rebateForms[0]) && SummaryTable(rebateForms)}
      </Fragment>
    );
  }
}

export default CustomersSummary;
