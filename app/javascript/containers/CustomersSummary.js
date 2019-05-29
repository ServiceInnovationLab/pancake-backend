
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
    this.state = { rebateForms: null, applicationState: 'not signed' };
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

  onSubmit(values = {}) {
    this.fetchRebates(`rebate_forms?utf8=✓&status=not signed&name=${values.name || ''}`);
  }

  render() {
    const { applicationState, rebateForms } = this.state;

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
